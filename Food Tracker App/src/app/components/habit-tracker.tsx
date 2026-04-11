import { useState } from 'react';
import { Check, Plus, X, Trash2 } from 'lucide-react';

interface Habit {
  id: string;
  name: string;
  icon: string;
  completedDates: string[];
  streak: number;
}

interface HabitTrackerProps {
  habits: Habit[];
  onToggleHabit: (habitId: string) => void;
  onAddHabit: (habit: Omit<Habit, 'id' | 'completedDates' | 'streak'>) => void;
  onDeleteHabit: (habitId: string) => void;
}

export function HabitTracker({ habits, onToggleHabit, onAddHabit, onDeleteHabit }: HabitTrackerProps) {
  const [showAddForm, setShowAddForm] = useState(false);
  const [newHabitName, setNewHabitName] = useState('');
  const [newHabitIcon, setNewHabitIcon] = useState('✅');

  const today = new Date().toISOString().split('T')[0];

  const isCompletedToday = (habit: Habit) => {
    return habit.completedDates.includes(today);
  };

  const handleAddHabit = () => {
    if (newHabitName.trim()) {
      onAddHabit({
        name: newHabitName.trim(),
        icon: newHabitIcon
      });
      setNewHabitName('');
      setNewHabitIcon('✅');
      setShowAddForm(false);
    }
  };

  const commonIcons = ['✅', '💧', '📚', '🧘', '🏃', '🥗', '😴', '🧠', '💪', '🎯', '📝', '🚫'];

  return (
    <div className="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-200 dark:border-gray-700 shadow-sm hover:shadow-md transition-all">
      <div className="flex items-center justify-between mb-4">
        <div>
          <h3 className="font-semibold text-gray-900 dark:text-white">Daily Habits</h3>
          <p className="text-xs text-gray-500 dark:text-gray-400">Build consistency 🎯</p>
        </div>
        <button
          onClick={() => setShowAddForm(!showAddForm)}
          className="p-2 bg-orange-100 dark:bg-orange-900/30 hover:bg-orange-200 dark:hover:bg-orange-900/50 text-orange-600 dark:text-orange-400 rounded-lg transition-colors"
        >
          {showAddForm ? <X className="w-5 h-5" /> : <Plus className="w-5 h-5" />}
        </button>
      </div>

      {showAddForm && (
        <div className="mb-4 p-4 bg-gray-50 dark:bg-gray-900/50 rounded-xl border border-gray-200 dark:border-gray-700">
          <div className="mb-3">
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Habit Name
            </label>
            <input
              type="text"
              value={newHabitName}
              onChange={(e) => setNewHabitName(e.target.value)}
              placeholder="e.g., Drink 8 glasses of water"
              className="w-full px-3 py-2 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white focus:ring-2 focus:ring-orange-500 focus:border-transparent"
              onKeyDown={(e) => e.key === 'Enter' && handleAddHabit()}
            />
          </div>
          <div className="mb-3">
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Choose Icon
            </label>
            <div className="grid grid-cols-6 gap-2">
              {commonIcons.map((icon) => (
                <button
                  key={icon}
                  onClick={() => setNewHabitIcon(icon)}
                  className={`p-2 text-2xl rounded-lg transition-all ${
                    newHabitIcon === icon
                      ? 'bg-orange-500 scale-110 shadow-md'
                      : 'bg-white dark:bg-gray-800 hover:bg-gray-100 dark:hover:bg-gray-700'
                  }`}
                >
                  {icon}
                </button>
              ))}
            </div>
          </div>
          <button
            onClick={handleAddHabit}
            disabled={!newHabitName.trim()}
            className="w-full py-2 bg-gradient-to-r from-orange-500 to-amber-600 hover:from-orange-600 hover:to-amber-700 disabled:from-gray-400 disabled:to-gray-500 disabled:cursor-not-allowed text-white rounded-lg font-medium transition-all"
          >
            Add Habit
          </button>
        </div>
      )}

      <div className="space-y-2">
        {habits.length === 0 ? (
          <div className="text-center py-8">
            <div className="text-4xl mb-2">🎯</div>
            <p className="text-sm text-gray-500 dark:text-gray-400">
              No habits yet. Add one to get started!
            </p>
          </div>
        ) : (
          habits.map((habit) => {
            const completed = isCompletedToday(habit);
            return (
              <div
                key={habit.id}
                className={`group flex items-center justify-between p-4 rounded-xl border-2 transition-all cursor-pointer ${
                  completed
                    ? 'bg-green-50 dark:bg-green-900/20 border-green-500 dark:border-green-500'
                    : 'bg-white dark:bg-gray-800 border-gray-200 dark:border-gray-700 hover:border-orange-500 dark:hover:border-orange-500'
                }`}
                onClick={() => onToggleHabit(habit.id)}
              >
                <div className="flex items-center gap-3 flex-1">
                  <div className="text-2xl">{habit.icon}</div>
                  <div className="flex-1">
                    <div className={`font-medium ${
                      completed 
                        ? 'text-green-700 dark:text-green-400 line-through' 
                        : 'text-gray-900 dark:text-white'
                    }`}>
                      {habit.name}
                    </div>
                    <div className="flex items-center gap-2 mt-1">
                      <span className="text-xs text-gray-500 dark:text-gray-400">
                        {habit.streak} day streak 🔥
                      </span>
                    </div>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <button
                    onClick={(e) => {
                      e.stopPropagation();
                      onDeleteHabit(habit.id);
                    }}
                    className="p-2 opacity-0 group-hover:opacity-100 hover:bg-red-100 dark:hover:bg-red-900/30 text-red-600 dark:text-red-400 rounded-lg transition-all"
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                  <div className={`w-8 h-8 rounded-lg flex items-center justify-center transition-all ${
                    completed
                      ? 'bg-green-500 text-white'
                      : 'bg-gray-200 dark:bg-gray-700 text-gray-400 dark:text-gray-500'
                  }`}>
                    {completed && <Check className="w-5 h-5" />}
                  </div>
                </div>
              </div>
            );
          })
        )}
      </div>

      {habits.length > 0 && (
        <div className="mt-4 pt-4 border-t border-gray-200 dark:border-gray-700">
          <div className="text-center">
            <div className="text-sm text-gray-600 dark:text-gray-400">
              {habits.filter(h => isCompletedToday(h)).length} of {habits.length} completed today
            </div>
            <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2 mt-2">
              <div
                className="bg-gradient-to-r from-green-500 to-emerald-600 h-2 rounded-full transition-all"
                style={{ width: `${(habits.filter(h => isCompletedToday(h)).length / habits.length) * 100}%` }}
              />
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
