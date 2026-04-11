// Utility function to generate dummy historical data
export function generateDummyData() {
  const today = new Date();
  
  // Generate food entries for the past 7 days
  const generateFoodEntries = () => {
    const foods = [];
    const indianMeals = [
      { name: 'Idli with Sambar', calories: 156, protein: 4, carbs: 34, fat: 0.4, fiber: 1.6, serving: '3 pieces' },
      { name: 'Poha', calories: 250, protein: 6, carbs: 45, fat: 6, fiber: 3, serving: '1 bowl' },
      { name: 'Dal Rice', calories: 320, protein: 12, carbs: 58, fat: 4, fiber: 6, serving: '1 plate' },
      { name: 'Rajma Chawal', calories: 380, protein: 15, carbs: 65, fat: 5, fiber: 8, serving: '1 plate' },
      { name: 'Paneer Tikka', calories: 280, protein: 18, carbs: 8, fat: 20, fiber: 2, serving: '6 pieces' },
      { name: 'Chicken Curry with Roti', calories: 450, protein: 32, carbs: 48, fat: 14, fiber: 4, serving: '1 plate' },
      { name: 'Dosa with Chutney', calories: 168, protein: 4, carbs: 28, fat: 4, fiber: 2, serving: '1 dosa' },
      { name: 'Curd Rice', calories: 180, protein: 5, carbs: 32, fat: 3, fiber: 1, serving: '1 bowl' },
    ];

    for (let daysAgo = 0; daysAgo < 7; daysAgo++) {
      const date = new Date(today);
      date.setDate(date.getDate() - daysAgo);
      
      // Breakfast
      const breakfast = indianMeals[Math.floor(Math.random() * 3)];
      foods.push({
        id: `food-${daysAgo}-1`,
        ...breakfast,
        timestamp: new Date(date.setHours(8, 30, 0)),
        mealType: 'Breakfast'
      });

      // Lunch
      const lunch = indianMeals[2 + Math.floor(Math.random() * 3)];
      foods.push({
        id: `food-${daysAgo}-2`,
        ...lunch,
        timestamp: new Date(date.setHours(13, 0, 0)),
        mealType: 'Lunch'
      });

      // Snack
      if (Math.random() > 0.3) {
        foods.push({
          id: `food-${daysAgo}-3`,
          name: 'Chai with Biscuits',
          calories: 120,
          protein: 2,
          carbs: 18,
          fat: 5,
          fiber: 0.5,
          serving: '1 cup',
          timestamp: new Date(date.setHours(17, 0, 0)),
          mealType: 'Snacks'
        });
      }

      // Dinner
      const dinner = indianMeals[5 + Math.floor(Math.random() * 2)];
      foods.push({
        id: `food-${daysAgo}-4`,
        ...dinner,
        timestamp: new Date(date.setHours(20, 30, 0)),
        mealType: 'Dinner'
      });
    }

    return foods;
  };

  // Generate exercise entries for the past 7 days
  const generateExerciseEntries = () => {
    const exercises = [];
    const indianExercises = [
      { name: 'Morning Walk', duration: 30, calories: 150, type: 'cardio' as const },
      { name: 'Yoga Session', duration: 45, calories: 180, type: 'flexibility' as const },
      { name: 'Badminton', duration: 45, calories: 320, type: 'sports' as const },
      { name: 'Gym Workout', duration: 60, calories: 350, type: 'strength' as const },
      { name: 'Cricket', duration: 60, calories: 350, type: 'sports' as const },
      { name: 'Cycling', duration: 40, calories: 280, type: 'cardio' as const },
    ];

    for (let daysAgo = 0; daysAgo < 7; daysAgo++) {
      const date = new Date(today);
      date.setDate(date.getDate() - daysAgo);
      
      // Morning exercise (70% chance)
      if (Math.random() > 0.3) {
        const morning = indianExercises[Math.floor(Math.random() * 2)];
        exercises.push({
          id: `exercise-${daysAgo}-1`,
          ...morning,
          timestamp: new Date(date.setHours(6, 30, 0))
        });
      }

      // Evening exercise (50% chance)
      if (Math.random() > 0.5) {
        const evening = indianExercises[2 + Math.floor(Math.random() * 4)];
        exercises.push({
          id: `exercise-${daysAgo}-2`,
          ...evening,
          timestamp: new Date(date.setHours(18, 0, 0))
        });
      }
    }

    return exercises;
  };

  // Generate daily stats for the past 7 days
  const generateWeeklyStats = () => {
    const stats = [];
    for (let daysAgo = 6; daysAgo >= 0; daysAgo--) {
      const date = new Date(today);
      date.setDate(date.getDate() - daysAgo);
      stats.push({
        date: date.toISOString(),
        steps: 5000 + Math.floor(Math.random() * 5000),
        calories: 1800 + Math.floor(Math.random() * 600),
        protein: 100 + Math.floor(Math.random() * 60),
        activeMinutes: 30 + Math.floor(Math.random() * 60),
        sleep: 6 + Math.random() * 2.5
      });
    }
    return stats;
  };

  return {
    foods: generateFoodEntries(),
    exercises: generateExerciseEntries(),
    weeklyStats: generateWeeklyStats()
  };
}

// Calculate totals for a specific date
export function calculateDailyTotals(foods: any[], exercises: any[], date: Date) {
  const startOfDay = new Date(date);
  startOfDay.setHours(0, 0, 0, 0);
  const endOfDay = new Date(date);
  endOfDay.setHours(23, 59, 59, 999);

  const dailyFoods = foods.filter(f => {
    const foodDate = new Date(f.timestamp);
    return foodDate >= startOfDay && foodDate <= endOfDay;
  });

  const dailyExercises = exercises.filter(e => {
    const exerciseDate = new Date(e.timestamp);
    return exerciseDate >= startOfDay && exerciseDate <= endOfDay;
  });

  return {
    calories: dailyFoods.reduce((sum, f) => sum + f.calories, 0),
    protein: dailyFoods.reduce((sum, f) => sum + f.protein, 0),
    carbs: dailyFoods.reduce((sum, f) => sum + f.carbs, 0),
    fat: dailyFoods.reduce((sum, f) => sum + f.fat, 0),
    fiber: dailyFoods.reduce((sum, f) => sum + f.fiber, 0),
    exerciseDuration: dailyExercises.reduce((sum, e) => sum + e.duration, 0),
    caloriesBurned: dailyExercises.reduce((sum, e) => sum + e.calories, 0)
  };
}
