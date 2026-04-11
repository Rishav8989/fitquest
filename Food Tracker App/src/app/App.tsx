import { useState, useEffect } from 'react';
import { Home, Moon, Sun, Sparkles, User, UtensilsCrossed, Map, Footprints, Dumbbell, Trophy } from 'lucide-react';
import { ThemeProvider, useTheme } from './components/theme-provider';
import { Onboarding } from './components/onboarding';
import { FoodEntryForm } from './components/food-entry-form';
import { ExerciseForm } from './components/exercise-form';
import { FoodLog } from './components/food-log';
import { ExerciseLog } from './components/exercise-log';
import { DailySummary } from './components/daily-summary';
import { GamificationPanel } from './components/gamification-panel';
import { ActivityTracker } from './components/activity-tracker';
import { SleepTracker } from './components/sleep-tracker';
import { AIRecommendations } from './components/ai-recommendations';
import { JourneyMap } from './components/journey-map';
import { ProfilePage } from './components/profile-page';
import { ConfirmDialog } from './components/confirm-dialog';
import { WorkoutTimer } from './components/workout-timer';
import { ExerciseLibraryBrowser } from './components/exercise-library-browser';
import { WaterTracker } from './components/water-tracker';
import { HabitTracker } from './components/habit-tracker';
import { QuickActions } from './components/quick-actions';
import { Calculators } from './components/calculators';
import { MeasurementsTracker } from './components/measurements-tracker';
import { generateDummyData } from './utils/dummy-data';

interface FoodItem {
  id: string;
  name: string;
  calories: number;
  protein: number;
  carbs: number;
  fat: number;
  fiber: number;
  serving: string;
  timestamp: Date;
  mealType: string;
}

interface ExerciseEntry {
  id: string;
  name: string;
  duration: number;
  calories: number;
  type: 'cardio' | 'strength' | 'flexibility' | 'sports';
  timestamp: Date;
}

interface UserProfile {
  name: string;
  age: number;
  gender: 'male' | 'female' | 'other';
  height: number;
  weight: number;
  activityLevel: 'sedentary' | 'light' | 'moderate' | 'active' | 'very-active';
  dietPlan: 'balanced' | 'keto' | 'low-carb' | 'high-protein' | 'vegan' | 'paleo';
  goal: 'lose-weight' | 'maintain' | 'gain-muscle' | 'improve-fitness';
  email?: string;
  phone?: string;
}

interface Achievement {
  id: string;
  title: string;
  description: string;
  icon: string;
  unlocked: boolean;
  unlockedDate?: string;
}

interface Habit {
  id: string;
  name: string;
  icon: string;
  completedDates: string[];
  streak: number;
}

interface Measurement {
  date: string;
  weight: number;
  chest?: number;
  waist?: number;
  hips?: number;
  arms?: number;
  thighs?: number;
}

function AppContent() {
  const { theme, toggleTheme } = useTheme();
  
  // UI State
  const [showOnboarding, setShowOnboarding] = useState(false);
  const [showProfile, setShowProfile] = useState(false);
  const [showFoodForm, setShowFoodForm] = useState(false);
  const [showExerciseForm, setShowExerciseForm] = useState(false);
  const [showTimer, setShowTimer] = useState(false);
  const [showExerciseLibrary, setShowExerciseLibrary] = useState(false);
  const [showCalculators, setShowCalculators] = useState(false);
  const [showMeasurements, setShowMeasurements] = useState(false);
  const [activeTab, setActiveTab] = useState<'home' | 'workout' | 'nutrition' | 'progress' | 'ai'>('home');

  // User Data
  const [userProfile, setUserProfile] = useState<UserProfile | null>(null);
  const [foods, setFoods] = useState<FoodItem[]>([]);
  const [exercises, setExercises] = useState<ExerciseEntry[]>([]);

  // Activity Data
  const [steps, setSteps] = useState(0);
  const [stepGoal] = useState(10000);
  const [activeMinutes, setActiveMinutes] = useState(0);
  const [distance, setDistance] = useState(0);
  const [isStepTracking, setIsStepTracking] = useState(false);

  // Water & Habits
  const [waterIntake, setWaterIntake] = useState(0);
  const [waterGoal] = useState(3000); // 3 liters
  const [habits, setHabits] = useState<Habit[]>([]);

  // Measurements
  const [measurements, setMeasurements] = useState<Measurement[]>([]);

  // Sleep Data
  const [sleepData, setSleepData] = useState({
    duration: 7.5,
    quality: 'good' as 'poor' | 'fair' | 'good' | 'excellent',
    bedtime: '22:30',
    wakeup: '06:00'
  });

  // Gamification
  const [userStats, setUserStats] = useState({
    points: 850,
    level: 9,
    streak: 15,
  });

  const [achievements, setAchievements] = useState<Achievement[]>([
    { id: '1', title: 'First Entry', description: 'Log your first meal', icon: '🎯', unlocked: true, unlockedDate: '2026-02-18' },
    { id: '2', title: 'Week Warrior', description: 'Log meals for 7 days straight', icon: '🔥', unlocked: true, unlockedDate: '2026-02-20' },
    { id: '3', title: 'Protein Pro', description: 'Hit protein goal 10 times', icon: '💪', unlocked: true, unlockedDate: '2026-02-22' },
    { id: '4', title: 'Workout Hero', description: 'Complete 5 workouts', icon: '🏋️', unlocked: true },
    { id: '5', title: '10K Steps', description: 'Reach 10,000 steps in a day', icon: '🚶', unlocked: false },
    { id: '6', title: 'Early Bird', description: 'Log breakfast before 8am 5 times', icon: '🌅', unlocked: false },
    { id: '7', title: 'Sleep Master', description: 'Get 8+ hours of sleep 7 days straight', icon: '😴', unlocked: false },
    { id: '8', title: 'Streak Master', description: 'Maintain a 30-day streak', icon: '⭐', unlocked: false },
    { id: '9', title: 'Hydration Hero', description: 'Meet water goal 7 days straight', icon: '💧', unlocked: false },
    { id: '10', title: 'Habit Master', description: 'Complete all daily habits for 14 days', icon: '✅', unlocked: false },
  ]);

  const [confirmDialog, setConfirmDialog] = useState<{
    isOpen: boolean;
    title: string;
    message: string;
    onConfirm: () => void;
    type?: 'success' | 'danger' | 'warning';
  }>({
    isOpen: false,
    title: '',
    message: '',
    onConfirm: () => {}
  });

  // Load data from localStorage on mount
  useEffect(() => {
    const savedProfile = localStorage.getItem('userProfile');
    const savedFoods = localStorage.getItem('foods');
    const savedExercises = localStorage.getItem('exercises');
    const savedStats = localStorage.getItem('userStats');
    const savedSteps = localStorage.getItem('steps');
    const savedWater = localStorage.getItem('waterIntake');
    const savedHabits = localStorage.getItem('habits');
    const savedMeasurements = localStorage.getItem('measurements');

    if (savedProfile) {
      setUserProfile(JSON.parse(savedProfile));
      setShowOnboarding(false);
    } else {
      setShowOnboarding(true);
    }

    if (savedFoods) {
      const parsedFoods = JSON.parse(savedFoods).map((f: any) => ({
        ...f,
        timestamp: new Date(f.timestamp)
      }));
      setFoods(parsedFoods);
    } else {
      const dummyData = generateDummyData();
      setFoods(dummyData.foods);
      setExercises(dummyData.exercises);
    }

    if (savedExercises) {
      const parsedExercises = JSON.parse(savedExercises).map((e: any) => ({
        ...e,
        timestamp: new Date(e.timestamp)
      }));
      setExercises(parsedExercises);
    }

    if (savedStats) {
      setUserStats(JSON.parse(savedStats));
    }

    if (savedSteps) {
      setSteps(parseInt(savedSteps));
    } else {
      setSteps(6543);
    }

    if (savedWater) {
      setWaterIntake(parseInt(savedWater));
    } else {
      setWaterIntake(1250);
    }

    if (savedHabits) {
      setHabits(JSON.parse(savedHabits));
    } else {
      setHabits([
        { id: '1', name: 'Drink 8 glasses of water', icon: '💧', completedDates: [], streak: 0 },
        { id: '2', name: 'Exercise for 30 minutes', icon: '🏃', completedDates: [], streak: 0 },
        { id: '3', name: 'Sleep 8 hours', icon: '😴', completedDates: [], streak: 0 },
      ]);
    }

    if (savedMeasurements) {
      setMeasurements(JSON.parse(savedMeasurements));
    }
  }, []);

  // Save data to localStorage
  useEffect(() => {
    if (userProfile) localStorage.setItem('userProfile', JSON.stringify(userProfile));
  }, [userProfile]);

  useEffect(() => {
    localStorage.setItem('foods', JSON.stringify(foods));
  }, [foods]);

  useEffect(() => {
    localStorage.setItem('exercises', JSON.stringify(exercises));
  }, [exercises]);

  useEffect(() => {
    localStorage.setItem('userStats', JSON.stringify(userStats));
  }, [userStats]);

  useEffect(() => {
    localStorage.setItem('steps', steps.toString());
  }, [steps]);

  useEffect(() => {
    localStorage.setItem('waterIntake', waterIntake.toString());
  }, [waterIntake]);

  useEffect(() => {
    localStorage.setItem('habits', JSON.stringify(habits));
  }, [habits]);

  useEffect(() => {
    localStorage.setItem('measurements', JSON.stringify(measurements));
  }, [measurements]);

  // Step tracking simulation
  useEffect(() => {
    let interval: any;
    if (isStepTracking) {
      interval = setInterval(() => {
        setSteps(prev => {
          const newSteps = prev + Math.floor(Math.random() * 5) + 1;
          if (newSteps >= stepGoal && prev < stepGoal) {
            unlockAchievement('5');
          }
          return newSteps;
        });
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [isStepTracking, stepGoal]);

  // Reset water daily
  useEffect(() => {
    const checkWaterReset = () => {
      const lastReset = localStorage.getItem('lastWaterReset');
      const today = new Date().toDateString();
      if (lastReset !== today) {
        setWaterIntake(0);
        localStorage.setItem('lastWaterReset', today);
      }
    };
    checkWaterReset();
    const interval = setInterval(checkWaterReset, 60000); // Check every minute
    return () => clearInterval(interval);
  }, []);

  const calculateGoals = () => {
    if (!userProfile) return { calories: 2000, protein: 150, carbs: 200, fat: 65 };

    const bmr = userProfile.gender === 'male'
      ? 10 * userProfile.weight + 6.25 * userProfile.height - 5 * userProfile.age + 5
      : 10 * userProfile.weight + 6.25 * userProfile.height - 5 * userProfile.age - 161;

    const activityMultipliers = {
      'sedentary': 1.2,
      'light': 1.375,
      'moderate': 1.55,
      'active': 1.725,
      'very-active': 1.9
    };

    let calories = bmr * activityMultipliers[userProfile.activityLevel];

    if (userProfile.goal === 'lose-weight') calories -= 500;
    if (userProfile.goal === 'gain-muscle') calories += 300;

    const protein = userProfile.goal === 'gain-muscle' 
      ? userProfile.weight * 2.2 
      : userProfile.weight * 1.6;

    let carbs = 0;
    let fat = 0;

    switch (userProfile.dietPlan) {
      case 'keto':
        carbs = 30;
        fat = (calories - (protein * 4) - (carbs * 4)) / 9;
        break;
      case 'low-carb':
        carbs = calories * 0.20 / 4;
        fat = (calories - (protein * 4) - (carbs * 4)) / 9;
        break;
      case 'high-protein':
        carbs = calories * 0.35 / 4;
        fat = (calories - (protein * 4) - (carbs * 4)) / 9;
        break;
      default:
        carbs = calories * 0.40 / 4;
        fat = (calories - (protein * 4) - (carbs * 4)) / 9;
    }

    return {
      calories: Math.round(calories),
      protein: Math.round(protein),
      carbs: Math.round(carbs),
      fat: Math.round(fat)
    };
  };

  const goals = calculateGoals();

  const getTodayData = () => {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    return {
      foods: foods.filter(f => {
        const foodDate = new Date(f.timestamp);
        return foodDate >= today && foodDate < tomorrow;
      }),
      exercises: exercises.filter(e => {
        const exerciseDate = new Date(e.timestamp);
        return exerciseDate >= today && exerciseDate < tomorrow;
      })
    };
  };

  const todayData = getTodayData();
  const totalCalories = todayData.foods.reduce((sum, food) => sum + food.calories, 0);
  const totalProtein = todayData.foods.reduce((sum, food) => sum + food.protein, 0);
  const totalCarbs = todayData.foods.reduce((sum, food) => sum + food.carbs, 0);
  const totalFat = todayData.foods.reduce((sum, food) => sum + food.fat, 0);
  const totalFiber = todayData.foods.reduce((sum, food) => sum + food.fiber, 0);
  const totalExerciseCalories = todayData.exercises.reduce((sum, ex) => sum + ex.calories, 0);
  const totalExerciseDuration = todayData.exercises.reduce((sum, ex) => sum + ex.duration, 0);

  useEffect(() => {
    setActiveMinutes(totalExerciseDuration);
    setDistance(steps / 1300);
  }, [totalExerciseDuration, steps]);

  const handleOnboardingComplete = (profile: UserProfile) => {
    setUserProfile(profile);
    setShowOnboarding(false);
  };

  const handleAddFoodRequest = (food: Omit<FoodItem, 'id' | 'timestamp' | 'mealType'>) => {
    setConfirmDialog({
      isOpen: true,
      title: 'Confirm Food Entry',
      message: `Add ${food.name} (${food.calories} cal)?`,
      onConfirm: () => confirmAddFood(food),
      type: 'success'
    });
  };

  const confirmAddFood = (food: any) => {
    const newFood: FoodItem = {
      ...food,
      id: Date.now().toString(),
      timestamp: new Date(),
      mealType: 'Breakfast',
    };
    
    setFoods(prev => [...prev, newFood]);
    setShowFoodForm(false);
    setConfirmDialog({ ...confirmDialog, isOpen: false });

    const pointsEarned = 10;
    setUserStats(prev => ({
      ...prev,
      points: prev.points + pointsEarned,
      level: Math.floor((prev.points + pointsEarned) / 100) + 1,
    }));
  };

  const handleAddExerciseRequest = (exercise: Omit<ExerciseEntry, 'id' | 'timestamp'>) => {
    setConfirmDialog({
      isOpen: true,
      title: 'Confirm Exercise Entry',
      message: `Add ${exercise.name} (${exercise.duration} min, ${exercise.calories} cal burned)?`,
      onConfirm: () => confirmAddExercise(exercise),
      type: 'success'
    });
  };

  const confirmAddExercise = (exercise: any) => {
    const newExercise: ExerciseEntry = {
      ...exercise,
      id: Date.now().toString(),
      timestamp: new Date()
    };

    setExercises(prev => [...prev, newExercise]);
    setShowExerciseForm(false);
    setConfirmDialog({ ...confirmDialog, isOpen: false });
    setSteps(prev => prev + Math.floor(exercise.duration * 100));

    const pointsEarned = 20;
    setUserStats(prev => ({
      ...prev,
      points: prev.points + pointsEarned,
      level: Math.floor((prev.points + pointsEarned) / 100) + 1,
    }));

    if (todayData.exercises.length === 4) {
      unlockAchievement('4');
    }
  };

  const handleDeleteFoodRequest = (id: string) => {
    const food = foods.find(f => f.id === id);
    setConfirmDialog({
      isOpen: true,
      title: 'Delete Food Entry',
      message: `Are you sure you want to delete ${food?.name}?`,
      onConfirm: () => confirmDeleteFood(id),
      type: 'danger'
    });
  };

  const confirmDeleteFood = (id: string) => {
    setFoods(prev => prev.filter(food => food.id !== id));
    setConfirmDialog({ ...confirmDialog, isOpen: false });
  };

  const handleDeleteExerciseRequest = (id: string) => {
    const exercise = exercises.find(e => e.id === id);
    setConfirmDialog({
      isOpen: true,
      title: 'Delete Exercise Entry',
      message: `Are you sure you want to delete ${exercise?.name}?`,
      onConfirm: () => confirmDeleteExercise(id),
      type: 'danger'
    });
  };

  const confirmDeleteExercise = (id: string) => {
    setExercises(prev => prev.filter(ex => ex.id !== id));
    setConfirmDialog({ ...confirmDialog, isOpen: false });
  };

  const handleUpdateSleep = (data: any) => {
    setSleepData(data);
    const pointsEarned = 15;
    setUserStats(prev => ({
      ...prev,
      points: prev.points + pointsEarned,
    }));
  };

  const unlockAchievement = (id: string) => {
    setAchievements(prev =>
      prev.map(achievement =>
        achievement.id === id && !achievement.unlocked
          ? { ...achievement, unlocked: true, unlockedDate: new Date().toISOString() }
          : achievement
      )
    );
    setUserStats(prev => ({
      ...prev,
      points: prev.points + 50,
    }));
  };

  const handleUpdateProfile = (profile: UserProfile) => {
    setUserProfile(profile);
    setShowProfile(false);
  };

  const toggleStepTracking = () => {
    setIsStepTracking(!isStepTracking);
  };

  const handleUpdateWater = (amount: number) => {
    setWaterIntake(amount);
    const pointsEarned = 5;
    setUserStats(prev => ({
      ...prev,
      points: prev.points + pointsEarned,
    }));
  };

  const handleResetWater = () => {
    setWaterIntake(0);
  };

  const handleToggleHabit = (habitId: string) => {
    const today = new Date().toISOString().split('T')[0];
    setHabits(prev => prev.map(habit => {
      if (habit.id === habitId) {
        const isCompleted = habit.completedDates.includes(today);
        let newCompletedDates: string[];
        let newStreak = habit.streak;

        if (isCompleted) {
          newCompletedDates = habit.completedDates.filter(d => d !== today);
          newStreak = Math.max(0, newStreak - 1);
        } else {
          newCompletedDates = [...habit.completedDates, today];
          newStreak = newStreak + 1;
          
          const pointsEarned = 5;
          setUserStats(prev => ({
            ...prev,
            points: prev.points + pointsEarned,
          }));
        }

        return {
          ...habit,
          completedDates: newCompletedDates,
          streak: newStreak
        };
      }
      return habit;
    }));
  };

  const handleAddHabit = (habit: Omit<Habit, 'id' | 'completedDates' | 'streak'>) => {
    const newHabit: Habit = {
      ...habit,
      id: Date.now().toString(),
      completedDates: [],
      streak: 0
    };
    setHabits(prev => [...prev, newHabit]);
  };

  const handleDeleteHabit = (habitId: string) => {
    setHabits(prev => prev.filter(h => h.id !== habitId));
  };

  const handleAddMeasurement = (measurement: Omit<Measurement, 'date'>) => {
    const newMeasurement: Measurement = {
      ...measurement,
      date: new Date().toISOString()
    };
    setMeasurements(prev => [newMeasurement, ...prev]);
    
    const pointsEarned = 10;
    setUserStats(prev => ({
      ...prev,
      points: prev.points + pointsEarned,
    }));
  };

  if (showOnboarding) {
    return <Onboarding onComplete={handleOnboardingComplete} />;
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 pb-20 transition-colors">
      {/* Header */}
      <header className="bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700 sticky top-0 z-40 transition-colors shadow-sm">
        <div className="max-w-md mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-xl font-bold text-gray-900 dark:text-white">NutriQuest 🇮🇳</h1>
              <p className="text-xs text-gray-500 dark:text-gray-400">Namaste, {userProfile?.name}!</p>
            </div>
            <div className="flex items-center gap-2">
              <div className="bg-gradient-to-r from-orange-500 to-amber-600 dark:from-orange-600 dark:to-amber-700 text-white px-3 py-1.5 rounded-full flex items-center gap-1.5 shadow-md hover:shadow-lg transition-all cursor-pointer">
                <Trophy className="w-4 h-4" />
                <span className="text-xs font-medium">Level {userStats.level}</span>
              </div>
              <button
                onClick={toggleTheme}
                className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-full transition-colors"
                title={theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode'}
              >
                {theme === 'dark' ? (
                  <Sun className="w-5 h-5 text-yellow-500" />
                ) : (
                  <Moon className="w-5 h-5 text-gray-600" />
                )}
              </button>
              <button 
                onClick={() => setShowProfile(true)}
                className="p-2 hover:bg-orange-50 dark:hover:bg-gray-700 rounded-full transition-colors"
                title="Open profile"
              >
                <User className="w-5 h-5 text-orange-600 dark:text-orange-400" />
              </button>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-md mx-auto px-4 py-6">
        {activeTab === 'home' && (
          <div className="space-y-6">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="text-2xl font-bold text-gray-900 dark:text-white">Dashboard</h2>
                <p className="text-sm text-gray-500 dark:text-gray-400">
                  {new Date().toLocaleDateString('en-IN', { weekday: 'long', day: 'numeric', month: 'short' })}
                </p>
              </div>
              <div className="text-right">
                <div className="text-sm text-gray-500 dark:text-gray-400">Streak</div>
                <div className="text-2xl font-bold text-orange-600 dark:text-orange-400 flex items-center gap-1">
                  🔥 {userStats.streak}
                </div>
              </div>
            </div>

            {/* Quick Stats Grid */}
            <div className="grid grid-cols-2 gap-3">
              <div className="bg-gradient-to-br from-blue-500 to-cyan-600 dark:from-blue-600 dark:to-cyan-700 rounded-2xl p-4 text-white shadow-lg hover:shadow-xl transition-all cursor-pointer">
                <Footprints className="w-8 h-8 mb-2 opacity-80" />
                <div className="text-2xl font-bold">{steps.toLocaleString()}</div>
                <div className="text-xs opacity-90">Steps Today</div>
              </div>
              <div className="bg-gradient-to-br from-orange-500 to-amber-600 dark:from-orange-600 dark:to-amber-700 rounded-2xl p-4 text-white shadow-lg hover:shadow-xl transition-all cursor-pointer">
                <UtensilsCrossed className="w-8 h-8 mb-2 opacity-80" />
                <div className="text-2xl font-bold">{totalCalories}</div>
                <div className="text-xs opacity-90">Calories</div>
              </div>
            </div>

            <DailySummary
              totalCalories={totalCalories}
              totalProtein={totalProtein}
              totalCarbs={totalCarbs}
              totalFat={totalFat}
              totalFiber={totalFiber}
              goals={goals}
            />

            <WaterTracker
              waterIntake={waterIntake}
              waterGoal={waterGoal}
              onUpdateWater={handleUpdateWater}
              onResetWater={handleResetWater}
            />

            <HabitTracker
              habits={habits}
              onToggleHabit={handleToggleHabit}
              onAddHabit={handleAddHabit}
              onDeleteHabit={handleDeleteHabit}
            />

            <ActivityTracker
              steps={steps}
              stepGoal={stepGoal}
              activeMinutes={activeMinutes}
              caloriesBurned={totalExerciseCalories}
              distance={distance}
            />
          </div>
        )}

        {activeTab === 'workout' && (
          <div className="space-y-6">
            <div className="flex items-center justify-between">
              <h2 className="text-2xl font-bold text-gray-900 dark:text-white">Workouts</h2>
              <button
                onClick={() => setShowTimer(true)}
                className="px-4 py-2 bg-green-500 hover:bg-green-600 dark:bg-green-600 dark:hover:bg-green-700 text-white rounded-xl font-medium shadow-md hover:shadow-lg transition-all"
              >
                Open Timer
              </button>
            </div>

            <div className="grid grid-cols-2 gap-3">
              <button
                onClick={() => setShowExerciseLibrary(true)}
                className="bg-gradient-to-br from-purple-500 to-pink-600 dark:from-purple-600 dark:to-pink-700 text-white rounded-2xl p-6 hover:shadow-xl transition-all cursor-pointer"
              >
                <Dumbbell className="w-8 h-8 mx-auto mb-2" />
                <div className="text-sm font-medium">200+ Exercises</div>
              </button>
              <button
                onClick={() => setShowExerciseForm(true)}
                className="bg-gradient-to-br from-blue-500 to-cyan-600 dark:from-blue-600 dark:to-cyan-700 text-white rounded-2xl p-6 hover:shadow-xl transition-all cursor-pointer"
              >
                <Footprints className="w-8 h-8 mx-auto mb-2" />
                <div className="text-sm font-medium">Log Exercise</div>
              </button>
            </div>

            <ActivityTracker
              steps={steps}
              stepGoal={stepGoal}
              activeMinutes={activeMinutes}
              caloriesBurned={totalExerciseCalories}
              distance={distance}
            />

            <ExerciseLog exercises={todayData.exercises} onDeleteExercise={handleDeleteExerciseRequest} />
          </div>
        )}

        {activeTab === 'nutrition' && (
          <div className="space-y-6">
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white">Nutrition</h2>

            <DailySummary
              totalCalories={totalCalories}
              totalProtein={totalProtein}
              totalCarbs={totalCarbs}
              totalFat={totalFat}
              totalFiber={totalFiber}
              goals={goals}
            />

            <FoodLog foods={todayData.foods} onDeleteFood={handleDeleteFoodRequest} />
          </div>
        )}

        {activeTab === 'progress' && (
          <div className="space-y-6">
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white">Progress</h2>

            <div className="grid grid-cols-2 gap-3">
              <button
                onClick={() => setShowCalculators(true)}
                className="bg-gradient-to-br from-indigo-500 to-purple-600 dark:from-indigo-600 dark:to-purple-700 text-white rounded-2xl p-6 hover:shadow-xl transition-all cursor-pointer"
              >
                <div className="text-3xl mb-2">🧮</div>
                <div className="text-sm font-medium">Calculators</div>
              </button>
              <button
                onClick={() => setShowMeasurements(true)}
                className="bg-gradient-to-br from-teal-500 to-cyan-600 dark:from-teal-600 dark:to-cyan-700 text-white rounded-2xl p-6 hover:shadow-xl transition-all cursor-pointer"
              >
                <div className="text-3xl mb-2">📏</div>
                <div className="text-sm font-medium">Measurements</div>
              </button>
            </div>

            <JourneyMap
              totalSteps={steps}
              totalDistance={distance}
              activeMinutes={activeMinutes}
            />

            <SleepTracker
              sleepData={sleepData}
              onUpdateSleep={handleUpdateSleep}
            />
          </div>
        )}

        {activeTab === 'ai' && (
          <div className="space-y-6">
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white">AI Coach</h2>

            <GamificationPanel
              points={userStats.points}
              level={userStats.level}
              streak={userStats.streak}
              achievements={achievements}
            />

            <AIRecommendations
              userProfile={{
                dietPlan: userProfile?.dietPlan || 'balanced',
                goal: userProfile?.goal || 'maintain',
                activityLevel: userProfile?.activityLevel || 'moderate'
              }}
              todayStats={{
                calories: totalCalories,
                protein: totalProtein,
                steps: steps,
                sleep: sleepData.duration
              }}
              exercises={todayData.exercises}
            />
          </div>
        )}
      </main>

      {/* Bottom Navigation */}
      <nav className="fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700 z-40 transition-colors shadow-2xl">
        <div className="max-w-md mx-auto px-2">
          <div className="flex items-center justify-around py-2">
            {[
              { id: 'home', icon: Home, label: 'Home' },
              { id: 'workout', icon: Dumbbell, label: 'Workout' },
              { id: 'nutrition', icon: UtensilsCrossed, label: 'Food' },
              { id: 'progress', icon: Map, label: 'Progress' },
              { id: 'ai', icon: Sparkles, label: 'AI' }
            ].map((tab) => {
              const Icon = tab.icon;
              const isActive = activeTab === tab.id;
              return (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id as any)}
                  className={`flex flex-col items-center gap-1 px-3 py-2 rounded-xl transition-all ${
                    isActive 
                      ? 'text-orange-600 dark:text-orange-400 bg-orange-50 dark:bg-orange-900/30 scale-110' 
                      : 'text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
                  }`}
                >
                  <Icon className="w-5 h-5" />
                  <span className="text-xs font-medium">{tab.label}</span>
                </button>
              );
            })}
          </div>
        </div>
      </nav>

      {/* Quick Actions FAB */}
      <QuickActions
        onOpenFoodForm={() => setShowFoodForm(true)}
        onOpenExerciseForm={() => setShowExerciseForm(true)}
        onOpenTimer={() => setShowTimer(true)}
        onOpenExerciseLibrary={() => setShowExerciseLibrary(true)}
        onOpenCalculators={() => setShowCalculators(true)}
        onOpenMeasurements={() => setShowMeasurements(true)}
        onOpenHabits={() => {}}
      />

      {/* Modals */}
      {showFoodForm && (
        <FoodEntryForm
          onAddFood={handleAddFoodRequest}
          onClose={() => setShowFoodForm(false)}
        />
      )}

      {showExerciseForm && (
        <ExerciseForm
          onAddExercise={handleAddExerciseRequest}
          onClose={() => setShowExerciseForm(false)}
        />
      )}

      {showProfile && userProfile && (
        <ProfilePage
          isOpen={showProfile}
          onClose={() => setShowProfile(false)}
          profile={userProfile}
          onUpdateProfile={handleUpdateProfile}
        />
      )}

      <WorkoutTimer
        isOpen={showTimer}
        onClose={() => setShowTimer(false)}
      />

      <ExerciseLibraryBrowser
        isOpen={showExerciseLibrary}
        onClose={() => setShowExerciseLibrary(false)}
      />

      <Calculators
        isOpen={showCalculators}
        onClose={() => setShowCalculators(false)}
        userProfile={userProfile ? {
          weight: userProfile.weight,
          height: userProfile.height,
          age: userProfile.age,
          gender: userProfile.gender,
          activityLevel: userProfile.activityLevel
        } : undefined}
      />

      <MeasurementsTracker
        isOpen={showMeasurements}
        onClose={() => setShowMeasurements(false)}
        measurements={measurements}
        onAddMeasurement={handleAddMeasurement}
      />

      <ConfirmDialog
        isOpen={confirmDialog.isOpen}
        title={confirmDialog.title}
        message={confirmDialog.message}
        onConfirm={confirmDialog.onConfirm}
        onCancel={() => setConfirmDialog({ ...confirmDialog, isOpen: false })}
        type={confirmDialog.type}
      />
    </div>
  );
}

export default function App() {
  return (
    <ThemeProvider>
      <AppContent />
    </ThemeProvider>
  );
}
