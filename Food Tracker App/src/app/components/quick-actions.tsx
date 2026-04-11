import { useState } from 'react';
import { Plus, X, UtensilsCrossed, Dumbbell, Timer, Droplet, ListChecks, Calculator, Camera, TrendingUp, BookOpen } from 'lucide-react';

interface QuickActionsProps {
  onOpenFoodForm: () => void;
  onOpenExerciseForm: () => void;
  onOpenTimer: () => void;
  onOpenExerciseLibrary: () => void;
  onOpenCalculators: () => void;
  onOpenMeasurements: () => void;
  onOpenHabits: () => void;
}

export function QuickActions({
  onOpenFoodForm,
  onOpenExerciseForm,
  onOpenTimer,
  onOpenExerciseLibrary,
  onOpenCalculators,
  onOpenMeasurements,
  onOpenHabits
}: QuickActionsProps) {
  const [isOpen, setIsOpen] = useState(false);

  const actions = [
    { icon: UtensilsCrossed, label: 'Log Food', onClick: onOpenFoodForm, color: 'orange' },
    { icon: Dumbbell, label: 'Log Exercise', onClick: onOpenExerciseForm, color: 'blue' },
    { icon: Timer, label: 'Timer', onClick: onOpenTimer, color: 'green' },
    { icon: BookOpen, label: 'Exercises', onClick: onOpenExerciseLibrary, color: 'purple' },
    { icon: ListChecks, label: 'Habits', onClick: onOpenHabits, color: 'pink' },
    { icon: Calculator, label: 'Calculators', onClick: onOpenCalculators, color: 'indigo' },
    { icon: TrendingUp, label: 'Measurements', onClick: onOpenMeasurements, color: 'teal' },
  ];

  const getColorClasses = (color: string) => {
    const colors: any = {
      orange: 'bg-orange-500 hover:bg-orange-600 dark:bg-orange-600 dark:hover:bg-orange-700',
      blue: 'bg-blue-500 hover:bg-blue-600 dark:bg-blue-600 dark:hover:bg-blue-700',
      green: 'bg-green-500 hover:bg-green-600 dark:bg-green-600 dark:hover:bg-green-700',
      purple: 'bg-purple-500 hover:bg-purple-600 dark:bg-purple-600 dark:hover:bg-purple-700',
      pink: 'bg-pink-500 hover:bg-pink-600 dark:bg-pink-600 dark:hover:bg-pink-700',
      indigo: 'bg-indigo-500 hover:bg-indigo-600 dark:bg-indigo-600 dark:hover:bg-indigo-700',
      teal: 'bg-teal-500 hover:bg-teal-600 dark:bg-teal-600 dark:hover:bg-teal-700',
    };
    return colors[color] || colors.orange;
  };

  return (
    <>
      {/* Floating Action Button */}
      <div className="fixed bottom-24 right-6 z-40">
        <button
          onClick={() => setIsOpen(!isOpen)}
          className={`w-16 h-16 rounded-full shadow-2xl flex items-center justify-center transition-all transform ${
            isOpen
              ? 'bg-red-500 hover:bg-red-600 dark:bg-red-600 dark:hover:bg-red-700 rotate-45 scale-110'
              : 'bg-gradient-to-r from-orange-500 to-amber-600 hover:from-orange-600 hover:to-amber-700 dark:from-orange-600 dark:to-amber-700 scale-100'
          }`}
        >
          {isOpen ? (
            <X className="w-8 h-8 text-white" />
          ) : (
            <Plus className="w-8 h-8 text-white" />
          )}
        </button>

        {/* Action Menu */}
        {isOpen && (
          <div className="absolute bottom-20 right-0 space-y-3 animate-in fade-in slide-in-from-bottom-5 duration-200">
            {actions.map((action, index) => {
              const Icon = action.icon;
              return (
                <div
                  key={action.label}
                  className="flex items-center gap-3 animate-in fade-in slide-in-from-right-5"
                  style={{ animationDelay: `${index * 50}ms` }}
                >
                  <div className="bg-white dark:bg-gray-800 px-3 py-2 rounded-lg shadow-lg border border-gray-200 dark:border-gray-700 whitespace-nowrap">
                    <span className="text-sm font-medium text-gray-900 dark:text-white">
                      {action.label}
                    </span>
                  </div>
                  <button
                    onClick={() => {
                      action.onClick();
                      setIsOpen(false);
                    }}
                    className={`w-14 h-14 rounded-full shadow-xl flex items-center justify-center transition-all transform hover:scale-110 text-white ${getColorClasses(action.color)}`}
                  >
                    <Icon className="w-6 h-6" />
                  </button>
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* Backdrop */}
      {isOpen && (
        <div
          className="fixed inset-0 bg-black/20 dark:bg-black/40 z-30 backdrop-blur-sm"
          onClick={() => setIsOpen(false)}
        />
      )}
    </>
  );
}
