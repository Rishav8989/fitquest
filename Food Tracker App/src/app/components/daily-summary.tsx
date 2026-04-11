import { TrendingUp, TrendingDown, Activity } from 'lucide-react';
import { motion } from 'motion/react';

interface DailySummaryProps {
  totalCalories: number;
  totalProtein: number;
  totalCarbs: number;
  totalFat: number;
  totalFiber: number;
  goals: {
    calories: number;
    protein: number;
    carbs: number;
    fat: number;
  };
}

export function DailySummary({ totalCalories, totalProtein, totalCarbs, totalFat, totalFiber, goals }: DailySummaryProps) {
  const caloriesPercent = (totalCalories / goals.calories) * 100;
  const proteinPercent = (totalProtein / goals.protein) * 100;
  const carbsPercent = (totalCarbs / goals.carbs) * 100;
  const fatPercent = (totalFat / goals.fat) * 100;

  const caloriesRemaining = Math.max(0, goals.calories - totalCalories);

  const NutrientProgress = ({ 
    label, 
    current, 
    goal, 
    percent, 
    color 
  }: { 
    label: string; 
    current: number; 
    goal: number; 
    percent: number; 
    color: string; 
  }) => (
    <div>
      <div className="flex items-center justify-between mb-2">
        <span className="text-sm text-gray-600 dark:text-gray-400">{label}</span>
        <div className="flex items-center gap-2">
          <span className="text-sm font-medium text-gray-900 dark:text-white">
            {current.toFixed(1)} / {goal}g
          </span>
          {percent >= 100 ? (
            <TrendingUp className="w-4 h-4 text-emerald-600 dark:text-emerald-400" />
          ) : (
            <TrendingDown className="w-4 h-4 text-gray-400 dark:text-gray-500" />
          )}
        </div>
      </div>
      <div className="h-2 bg-gray-100 dark:bg-gray-700 rounded-full overflow-hidden">
        <motion.div
          initial={{ width: 0 }}
          animate={{ width: `${Math.min(percent, 100)}%` }}
          transition={{ duration: 0.5, ease: "easeOut" }}
          className="h-full rounded-full"
          style={{ backgroundColor: color }}
        />
      </div>
      <div className="text-xs text-gray-500 dark:text-gray-400 mt-1">
        {percent >= 100 ? (
          <span className="text-emerald-600 dark:text-emerald-400 font-medium">Goal reached! 🎉</span>
        ) : (
          `${(100 - percent).toFixed(0)}% remaining`
        )}
      </div>
    </div>
  );

  return (
    <div className="space-y-6">
      <div className="bg-gradient-to-br from-purple-500 to-indigo-600 dark:from-purple-600 dark:to-indigo-700 rounded-2xl p-6 text-white">
        <div className="flex items-center gap-2 mb-4">
          <Activity className="w-5 h-5" />
          <h3 className="font-semibold">Daily Summary</h3>
        </div>
        
        <div className="mb-4">
          <div className="text-sm opacity-90 mb-1">Calories</div>
          <div className="flex items-baseline gap-2">
            <span className="text-4xl font-bold">{totalCalories}</span>
            <span className="text-lg opacity-90">/ {goals.calories}</span>
          </div>
        </div>

        <div className="bg-white/20 backdrop-blur-sm rounded-lg p-4">
          <div className="flex items-center justify-between mb-2">
            <span className="text-sm">Daily Progress</span>
            <span className="text-sm font-medium">{caloriesPercent.toFixed(0)}%</span>
          </div>
          <div className="h-3 bg-white/20 rounded-full overflow-hidden">
            <motion.div
              initial={{ width: 0 }}
              animate={{ width: `${Math.min(caloriesPercent, 100)}%` }}
              transition={{ duration: 0.8, ease: "easeOut" }}
              className="h-full bg-white rounded-full"
            />
          </div>
          <div className="text-sm mt-2">
            {caloriesRemaining > 0 ? (
              <>
                <span className="opacity-90">{caloriesRemaining}</span> calories remaining
              </>
            ) : (
              <span className="font-medium">Daily goal reached! 🎯</span>
            )}
          </div>
        </div>
      </div>

      <div className="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl p-6">
        <h3 className="font-semibold text-gray-900 dark:text-white mb-4">Macronutrients</h3>
        <div className="space-y-4">
          <NutrientProgress
            label="Protein"
            current={totalProtein}
            goal={goals.protein}
            percent={proteinPercent}
            color="#10b981"
          />
          <NutrientProgress
            label="Carbohydrates"
            current={totalCarbs}
            goal={goals.carbs}
            percent={carbsPercent}
            color="#3b82f6"
          />
          <NutrientProgress
            label="Fat"
            current={totalFat}
            goal={goals.fat}
            percent={fatPercent}
            color="#f59e0b"
          />
        </div>

        {totalFiber > 0 && (
          <div className="mt-6 pt-4 border-t border-gray-200 dark:border-gray-700">
            <div className="flex items-center justify-between">
              <span className="text-sm text-gray-600 dark:text-gray-400">Fiber</span>
              <span className="text-sm font-medium text-gray-900 dark:text-white">{totalFiber.toFixed(1)}g</span>
            </div>
            <div className="text-xs text-gray-500 dark:text-gray-400 mt-1">
              Recommended: 25-30g daily
            </div>
          </div>
        )}
      </div>
    </div>
  );
}