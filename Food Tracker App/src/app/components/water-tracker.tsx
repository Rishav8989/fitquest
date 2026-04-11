import { Droplet, Plus, Minus, RotateCcw } from 'lucide-react';

interface WaterTrackerProps {
  waterIntake: number;
  waterGoal: number;
  onUpdateWater: (amount: number) => void;
  onResetWater: () => void;
}

export function WaterTracker({ waterIntake, waterGoal, onUpdateWater, onResetWater }: WaterTrackerProps) {
  const percentage = Math.min((waterIntake / waterGoal) * 100, 100);
  const glassSize = 250; // ml

  return (
    <div className="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-200 dark:border-gray-700 shadow-sm hover:shadow-md transition-all">
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center gap-2">
          <div className="p-2 bg-blue-100 dark:bg-blue-900/30 rounded-xl">
            <Droplet className="w-5 h-5 text-blue-600 dark:text-blue-400" />
          </div>
          <div>
            <h3 className="font-semibold text-gray-900 dark:text-white">Water Intake</h3>
            <p className="text-xs text-gray-500 dark:text-gray-400">Stay hydrated 💧</p>
          </div>
        </div>
        <button
          onClick={onResetWater}
          className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors"
          title="Reset daily intake"
        >
          <RotateCcw className="w-4 h-4 text-gray-500 dark:text-gray-400" />
        </button>
      </div>

      {/* Water Level Visualization */}
      <div className="relative h-32 bg-gray-100 dark:bg-gray-900/50 rounded-2xl overflow-hidden mb-4">
        <div
          className="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-blue-500 to-cyan-400 dark:from-blue-600 dark:to-cyan-500 transition-all duration-500 ease-out"
          style={{ height: `${percentage}%` }}
        >
          <div className="absolute inset-0 opacity-30">
            <div className="h-full flex items-center justify-center">
              <div className="w-full h-6 bg-white/10 animate-pulse" style={{ animationDuration: '3s' }}></div>
            </div>
          </div>
        </div>
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="text-center">
            <div className="text-3xl font-bold text-gray-900 dark:text-white">
              {waterIntake}ml
            </div>
            <div className="text-sm text-gray-600 dark:text-gray-400">
              / {waterGoal}ml
            </div>
          </div>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="grid grid-cols-4 gap-2 mb-3">
        {[250, 500, 750, 1000].map((amount) => (
          <button
            key={amount}
            onClick={() => onUpdateWater(waterIntake + amount)}
            className="py-2 bg-blue-50 dark:bg-blue-900/30 hover:bg-blue-100 dark:hover:bg-blue-900/50 text-blue-600 dark:text-blue-400 rounded-xl text-xs font-medium transition-colors"
          >
            +{amount}
          </button>
        ))}
      </div>

      {/* Glass Controls */}
      <div className="flex items-center justify-between gap-3">
        <button
          onClick={() => onUpdateWater(Math.max(0, waterIntake - glassSize))}
          disabled={waterIntake === 0}
          className="flex-1 py-3 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 disabled:opacity-50 disabled:cursor-not-allowed rounded-xl font-medium text-gray-700 dark:text-gray-300 flex items-center justify-center gap-2 transition-colors"
        >
          <Minus className="w-4 h-4" />
          Glass
        </button>
        <button
          onClick={() => onUpdateWater(waterIntake + glassSize)}
          className="flex-1 py-3 bg-gradient-to-r from-blue-500 to-cyan-600 hover:from-blue-600 hover:to-cyan-700 text-white rounded-xl font-medium flex items-center justify-center gap-2 shadow-md hover:shadow-lg transition-all"
        >
          <Plus className="w-4 h-4" />
          Glass
        </button>
      </div>

      {/* Progress Text */}
      {percentage >= 100 ? (
        <div className="mt-3 text-center text-sm font-medium text-green-600 dark:text-green-400 bg-green-50 dark:bg-green-900/30 py-2 rounded-lg">
          🎉 Goal reached! Great hydration!
        </div>
      ) : percentage >= 75 ? (
        <div className="mt-3 text-center text-sm text-blue-600 dark:text-blue-400">
          Almost there! Keep going 💪
        </div>
      ) : (
        <div className="mt-3 text-center text-sm text-gray-600 dark:text-gray-400">
          {Math.round((waterGoal - waterIntake) / glassSize)} glasses to go
        </div>
      )}
    </div>
  );
}
