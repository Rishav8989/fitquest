import { useState } from 'react';
import { X, Calculator, Activity, TrendingUp } from 'lucide-react';

interface CalculatorsProps {
  isOpen: boolean;
  onClose: () => void;
  userProfile?: {
    weight: number;
    height: number;
    age: number;
    gender: 'male' | 'female' | 'other';
    activityLevel: string;
  };
}

export function Calculators({ isOpen, onClose, userProfile }: CalculatorsProps) {
  const [activeCalc, setActiveCalc] = useState<'bmi' | 'bmr' | 'tdee' | 'macro'>('bmi');
  
  // BMI
  const [bmiWeight, setBmiWeight] = useState(userProfile?.weight || 70);
  const [bmiHeight, setBmiHeight] = useState(userProfile?.height || 170);
  
  // BMR/TDEE
  const [bmrWeight, setBmrWeight] = useState(userProfile?.weight || 70);
  const [bmrHeight, setBmrHeight] = useState(userProfile?.height || 170);
  const [bmrAge, setBmrAge] = useState(userProfile?.age || 30);
  const [bmrGender, setBmrGender] = useState<'male' | 'female'>(userProfile?.gender === 'female' ? 'female' : 'male');
  const [tdeeActivity, setTdeeActivity] = useState('moderate');
  
  // Macro Calculator
  const [macroCalories, setMacroCalories] = useState(2000);
  const [macroGoal, setMacroGoal] = useState('balanced');

  if (!isOpen) return null;

  // Calculations
  const calculateBMI = () => {
    const heightInMeters = bmiHeight / 100;
    const bmi = bmiWeight / (heightInMeters * heightInMeters);
    return bmi.toFixed(1);
  };

  const getBMICategory = (bmi: number) => {
    if (bmi < 18.5) return { text: 'Underweight', color: 'text-blue-600 dark:text-blue-400', bg: 'bg-blue-50 dark:bg-blue-900/30' };
    if (bmi < 25) return { text: 'Normal', color: 'text-green-600 dark:text-green-400', bg: 'bg-green-50 dark:bg-green-900/30' };
    if (bmi < 30) return { text: 'Overweight', color: 'text-yellow-600 dark:text-yellow-400', bg: 'bg-yellow-50 dark:bg-yellow-900/30' };
    return { text: 'Obese', color: 'text-red-600 dark:text-red-400', bg: 'bg-red-50 dark:bg-red-900/30' };
  };

  const calculateBMR = () => {
    if (bmrGender === 'male') {
      return Math.round(10 * bmrWeight + 6.25 * bmrHeight - 5 * bmrAge + 5);
    } else {
      return Math.round(10 * bmrWeight + 6.25 * bmrHeight - 5 * bmrAge - 161);
    }
  };

  const calculateTDEE = () => {
    const bmr = calculateBMR();
    const multipliers: any = {
      sedentary: 1.2,
      light: 1.375,
      moderate: 1.55,
      active: 1.725,
      'very-active': 1.9
    };
    return Math.round(bmr * multipliers[tdeeActivity]);
  };

  const calculateMacros = () => {
    let proteinPercent = 0.30;
    let carbsPercent = 0.40;
    let fatPercent = 0.30;

    if (macroGoal === 'low-carb') {
      proteinPercent = 0.40;
      carbsPercent = 0.20;
      fatPercent = 0.40;
    } else if (macroGoal === 'high-protein') {
      proteinPercent = 0.40;
      carbsPercent = 0.35;
      fatPercent = 0.25;
    } else if (macroGoal === 'keto') {
      proteinPercent = 0.25;
      carbsPercent = 0.05;
      fatPercent = 0.70;
    }

    return {
      protein: Math.round((macroCalories * proteinPercent) / 4),
      carbs: Math.round((macroCalories * carbsPercent) / 4),
      fat: Math.round((macroCalories * fatPercent) / 9)
    };
  };

  const bmi = parseFloat(calculateBMI());
  const bmiCategory = getBMICategory(bmi);
  const bmr = calculateBMR();
  const tdee = calculateTDEE();
  const macros = calculateMacros();

  return (
    <div className="fixed inset-0 bg-black/60 z-50 flex items-center justify-center p-4 backdrop-blur-sm overflow-y-auto">
      <div className="bg-white dark:bg-gray-800 rounded-3xl max-w-2xl w-full my-8 shadow-2xl border border-gray-200 dark:border-gray-700">
        {/* Header */}
        <div className="bg-gradient-to-r from-indigo-500 to-purple-600 dark:from-indigo-600 dark:to-purple-700 p-6 text-white rounded-t-3xl">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-white/20 rounded-xl">
                <Calculator className="w-6 h-6" />
              </div>
              <div>
                <h2 className="text-2xl font-bold">Health Calculators</h2>
                <p className="text-sm text-white/90">Calculate your health metrics</p>
              </div>
            </div>
            <button 
              onClick={onClose}
              className="p-2 hover:bg-white/20 rounded-full transition-colors"
            >
              <X className="w-6 h-6" />
            </button>
          </div>

          {/* Calculator Tabs */}
          <div className="grid grid-cols-4 gap-2">
            {[
              { id: 'bmi', label: 'BMI' },
              { id: 'bmr', label: 'BMR' },
              { id: 'tdee', label: 'TDEE' },
              { id: 'macro', label: 'Macros' }
            ].map((calc) => (
              <button
                key={calc.id}
                onClick={() => setActiveCalc(calc.id as any)}
                className={`py-2 px-3 rounded-xl font-medium text-sm transition-all ${
                  activeCalc === calc.id
                    ? 'bg-white text-indigo-600 shadow-lg'
                    : 'bg-white/20 hover:bg-white/30'
                }`}
              >
                {calc.label}
              </button>
            ))}
          </div>
        </div>

        {/* Calculator Content */}
        <div className="p-6">
          {activeCalc === 'bmi' && (
            <div className="space-y-6">
              <div>
                <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
                  Body Mass Index Calculator
                </h3>
                <p className="text-sm text-gray-600 dark:text-gray-400 mb-4">
                  BMI is a measure of body fat based on height and weight
                </p>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    Weight (kg)
                  </label>
                  <input
                    type="number"
                    value={bmiWeight}
                    onChange={(e) => setBmiWeight(parseFloat(e.target.value) || 0)}
                    className="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    Height (cm)
                  </label>
                  <input
                    type="number"
                    value={bmiHeight}
                    onChange={(e) => setBmiHeight(parseFloat(e.target.value) || 0)}
                    className="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                  />
                </div>
              </div>

              <div className="bg-gradient-to-br from-indigo-50 to-purple-50 dark:from-indigo-900/30 dark:to-purple-900/30 rounded-2xl p-6 border border-indigo-200 dark:border-indigo-800">
                <div className="text-center mb-4">
                  <div className="text-5xl font-bold text-indigo-600 dark:text-indigo-400 mb-2">
                    {bmi}
                  </div>
                  <div className={`inline-block px-4 py-2 rounded-full font-semibold ${bmiCategory.bg} ${bmiCategory.color}`}>
                    {bmiCategory.text}
                  </div>
                </div>
                <div className="grid grid-cols-4 gap-2 text-xs">
                  <div className="text-center">
                    <div className="h-2 bg-blue-500 rounded mb-1"></div>
                    <div className="text-gray-600 dark:text-gray-400">&lt;18.5</div>
                  </div>
                  <div className="text-center">
                    <div className="h-2 bg-green-500 rounded mb-1"></div>
                    <div className="text-gray-600 dark:text-gray-400">18.5-25</div>
                  </div>
                  <div className="text-center">
                    <div className="h-2 bg-yellow-500 rounded mb-1"></div>
                    <div className="text-gray-600 dark:text-gray-400">25-30</div>
                  </div>
                  <div className="text-center">
                    <div className="h-2 bg-red-500 rounded mb-1"></div>
                    <div className="text-gray-600 dark:text-gray-400">&gt;30</div>
                  </div>
                </div>
              </div>
            </div>
          )}

          {activeCalc === 'bmr' && (
            <div className="space-y-6">
              <div>
                <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
                  Basal Metabolic Rate Calculator
                </h3>
                <p className="text-sm text-gray-600 dark:text-gray-400 mb-4">
                  BMR is the number of calories your body burns at rest
                </p>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    Weight (kg)
                  </label>
                  <input
                    type="number"
                    value={bmrWeight}
                    onChange={(e) => setBmrWeight(parseFloat(e.target.value) || 0)}
                    className="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    Height (cm)
                  </label>
                  <input
                    type="number"
                    value={bmrHeight}
                    onChange={(e) => setBmrHeight(parseFloat(e.target.value) || 0)}
                    className="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    Age
                  </label>
                  <input
                    type="number"
                    value={bmrAge}
                    onChange={(e) => setBmrAge(parseFloat(e.target.value) || 0)}
                    className="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    Gender
                  </label>
                  <select
                    value={bmrGender}
                    onChange={(e) => setBmrGender(e.target.value as 'male' | 'female')}
                    className="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                  >
                    <option value="male">Male</option>
                    <option value="female">Female</option>
                  </select>
                </div>
              </div>

              <div className="bg-gradient-to-br from-indigo-50 to-purple-50 dark:from-indigo-900/30 dark:to-purple-900/30 rounded-2xl p-6 border border-indigo-200 dark:border-indigo-800 text-center">
                <div className="text-sm text-gray-600 dark:text-gray-400 mb-2">Your BMR</div>
                <div className="text-5xl font-bold text-indigo-600 dark:text-indigo-400 mb-2">
                  {bmr}
                </div>
                <div className="text-sm text-gray-600 dark:text-gray-400">calories/day</div>
                <p className="text-xs text-gray-500 dark:text-gray-500 mt-4">
                  This is how many calories you burn at complete rest
                </p>
              </div>
            </div>
          )}

          {activeCalc === 'tdee' && (
            <div className="space-y-6">
              <div>
                <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
                  Total Daily Energy Expenditure
                </h3>
                <p className="text-sm text-gray-600 dark:text-gray-400 mb-4">
                  TDEE is your total calories burned per day including activity
                </p>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Activity Level
                </label>
                <select
                  value={tdeeActivity}
                  onChange={(e) => setTdeeActivity(e.target.value)}
                  className="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                >
                  <option value="sedentary">Sedentary (little or no exercise)</option>
                  <option value="light">Light (exercise 1-3 days/week)</option>
                  <option value="moderate">Moderate (exercise 3-5 days/week)</option>
                  <option value="active">Active (exercise 6-7 days/week)</option>
                  <option value="very-active">Very Active (hard exercise daily)</option>
                </select>
              </div>

              <div className="bg-gradient-to-br from-indigo-50 to-purple-50 dark:from-indigo-900/30 dark:to-purple-900/30 rounded-2xl p-6 border border-indigo-200 dark:border-indigo-800">
                <div className="grid grid-cols-2 gap-4 text-center mb-4">
                  <div>
                    <div className="text-sm text-gray-600 dark:text-gray-400 mb-1">BMR</div>
                    <div className="text-2xl font-bold text-gray-900 dark:text-white">{bmr}</div>
                  </div>
                  <div>
                    <div className="text-sm text-gray-600 dark:text-gray-400 mb-1">TDEE</div>
                    <div className="text-2xl font-bold text-indigo-600 dark:text-indigo-400">{tdee}</div>
                  </div>
                </div>
                <div className="space-y-2 text-sm">
                  <div className="flex justify-between p-2 bg-white dark:bg-gray-800 rounded-lg">
                    <span className="text-gray-600 dark:text-gray-400">Weight Loss (-500 cal)</span>
                    <span className="font-semibold text-gray-900 dark:text-white">{tdee - 500}</span>
                  </div>
                  <div className="flex justify-between p-2 bg-white dark:bg-gray-800 rounded-lg">
                    <span className="text-gray-600 dark:text-gray-400">Maintain Weight</span>
                    <span className="font-semibold text-gray-900 dark:text-white">{tdee}</span>
                  </div>
                  <div className="flex justify-between p-2 bg-white dark:bg-gray-800 rounded-lg">
                    <span className="text-gray-600 dark:text-gray-400">Weight Gain (+300 cal)</span>
                    <span className="font-semibold text-gray-900 dark:text-white">{tdee + 300}</span>
                  </div>
                </div>
              </div>
            </div>
          )}

          {activeCalc === 'macro' && (
            <div className="space-y-6">
              <div>
                <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
                  Macro Calculator
                </h3>
                <p className="text-sm text-gray-600 dark:text-gray-400 mb-4">
                  Calculate your protein, carbs, and fat needs
                </p>
              </div>

              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    Daily Calories
                  </label>
                  <input
                    type="number"
                    value={macroCalories}
                    onChange={(e) => setMacroCalories(parseFloat(e.target.value) || 0)}
                    className="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    Diet Type
                  </label>
                  <select
                    value={macroGoal}
                    onChange={(e) => setMacroGoal(e.target.value)}
                    className="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                  >
                    <option value="balanced">Balanced</option>
                    <option value="high-protein">High Protein</option>
                    <option value="low-carb">Low Carb</option>
                    <option value="keto">Keto</option>
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-3 gap-4">
                <div className="bg-gradient-to-br from-orange-50 to-amber-50 dark:from-orange-900/30 dark:to-amber-900/30 rounded-2xl p-4 border border-orange-200 dark:border-orange-800 text-center">
                  <div className="text-sm text-gray-600 dark:text-gray-400 mb-1">Protein</div>
                  <div className="text-3xl font-bold text-orange-600 dark:text-orange-400 mb-1">
                    {macros.protein}g
                  </div>
                  <div className="text-xs text-gray-500 dark:text-gray-500">
                    {Math.round((macros.protein * 4 / macroCalories) * 100)}%
                  </div>
                </div>
                <div className="bg-gradient-to-br from-green-50 to-emerald-50 dark:from-green-900/30 dark:to-emerald-900/30 rounded-2xl p-4 border border-green-200 dark:border-green-800 text-center">
                  <div className="text-sm text-gray-600 dark:text-gray-400 mb-1">Carbs</div>
                  <div className="text-3xl font-bold text-green-600 dark:text-green-400 mb-1">
                    {macros.carbs}g
                  </div>
                  <div className="text-xs text-gray-500 dark:text-gray-500">
                    {Math.round((macros.carbs * 4 / macroCalories) * 100)}%
                  </div>
                </div>
                <div className="bg-gradient-to-br from-purple-50 to-pink-50 dark:from-purple-900/30 dark:to-pink-900/30 rounded-2xl p-4 border border-purple-200 dark:border-purple-800 text-center">
                  <div className="text-sm text-gray-600 dark:text-gray-400 mb-1">Fat</div>
                  <div className="text-3xl font-bold text-purple-600 dark:text-purple-400 mb-1">
                    {macros.fat}g
                  </div>
                  <div className="text-xs text-gray-500 dark:text-gray-500">
                    {Math.round((macros.fat * 9 / macroCalories) * 100)}%
                  </div>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
