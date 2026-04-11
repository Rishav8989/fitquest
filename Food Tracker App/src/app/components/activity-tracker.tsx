import { Footprints, Activity, Flame, Target, TrendingUp } from 'lucide-react';
import { motion } from 'motion/react';

interface ActivityTrackerProps {
  steps: number;
  stepGoal: number;
  activeMinutes: number;
  caloriesBurned: number;
  distance: number;
}

export function ActivityTracker({ 
  steps, 
  stepGoal, 
  activeMinutes, 
  caloriesBurned,
  distance 
}: ActivityTrackerProps) {
  const stepsPercent = (steps / stepGoal) * 100;

  return (
    <div className="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-200 dark:border-gray-700">
      <div className="flex items-center gap-2 mb-6">
        <Footprints className="w-5 h-5 text-blue-600 dark:text-blue-400" />
        <h3 className="font-semibold text-gray-900 dark:text-white">Daily Activity</h3>
      </div>

      <div className="mb-6">
        <div className="flex items-baseline gap-2 mb-2">
          <span className="text-4xl font-bold text-gray-900 dark:text-white">{steps.toLocaleString()}</span>
          <span className="text-lg text-gray-500 dark:text-gray-400">/ {stepGoal.toLocaleString()}</span>
        </div>
        <div className="text-sm text-gray-600 dark:text-gray-400 mb-3">steps today</div>
        
        <div className="relative h-3 bg-gray-100 dark:bg-gray-700 rounded-full overflow-hidden">
          <motion.div
            initial={{ width: 0 }}
            animate={{ width: `${Math.min(stepsPercent, 100)}%` }}
            transition={{ duration: 1, ease: "easeOut" }}
            className="absolute inset-y-0 left-0 bg-gradient-to-r from-blue-500 to-cyan-500 rounded-full"
          />
        </div>
        
        {stepsPercent >= 100 ? (
          <div className="text-sm text-emerald-600 dark:text-emerald-400 font-medium mt-2">
            🎉 Daily goal achieved!
          </div>
        ) : (
          <div className="text-sm text-gray-600 dark:text-gray-400 mt-2">
            {(stepGoal - steps).toLocaleString()} steps to go
          </div>
        )}
      </div>

      <div className="grid grid-cols-3 gap-3">
        <div className="bg-gradient-to-br from-orange-50 to-red-50 dark:from-orange-900/20 dark:to-red-900/20 rounded-xl p-4 text-center">
          <Flame className="w-5 h-5 text-orange-600 dark:text-orange-400 mx-auto mb-2" />
          <div className="text-xs text-gray-600 dark:text-gray-400 mb-1">Calories</div>
          <div className="text-lg font-bold text-gray-900 dark:text-white">{caloriesBurned}</div>
        </div>

        <div className="bg-gradient-to-br from-purple-50 to-pink-50 dark:from-purple-900/20 dark:to-pink-900/20 rounded-xl p-4 text-center">
          <Activity className="w-5 h-5 text-purple-600 dark:text-purple-400 mx-auto mb-2" />
          <div className="text-xs text-gray-600 dark:text-gray-400 mb-1">Active Min</div>
          <div className="text-lg font-bold text-gray-900 dark:text-white">{activeMinutes}</div>
        </div>

        <div className="bg-gradient-to-br from-blue-50 to-cyan-50 dark:from-blue-900/20 dark:to-cyan-900/20 rounded-xl p-4 text-center">
          <TrendingUp className="w-5 h-5 text-blue-600 dark:text-blue-400 mx-auto mb-2" />
          <div className="text-xs text-gray-600 dark:text-gray-400 mb-1">Distance</div>
          <div className="text-lg font-bold text-gray-900 dark:text-white">{distance.toFixed(1)} km</div>
        </div>
      </div>

      <div className="mt-4 bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-xl p-4">
        <div className="text-sm font-medium text-blue-900 dark:text-blue-300 mb-1">
          💪 Activity Goal
        </div>
        <div className="text-xs text-blue-700 dark:text-blue-400">
          {activeMinutes >= 30 
            ? 'Excellent! You\'ve met the recommended 30 minutes of activity.'
            : `Just ${30 - activeMinutes} more minutes to reach your daily activity goal!`}
        </div>
      </div>
    </div>
  );
}