import { Trash2, Clock } from 'lucide-react';
import { motion } from 'motion/react';

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

interface FoodLogProps {
  foods: FoodItem[];
  onDeleteFood: (id: string) => void;
}

export function FoodLog({ foods, onDeleteFood }: FoodLogProps) {
  const mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
  
  const groupedFoods = mealTypes.map(mealType => ({
    mealType,
    items: foods.filter(f => f.mealType === mealType)
  }));

  const formatTime = (date: Date) => {
    return new Date(date).toLocaleTimeString('en-US', { 
      hour: 'numeric', 
      minute: '2-digit',
      hour12: true 
    });
  };

  const getMealTypeIcon = (mealType: string) => {
    const icons: { [key: string]: string } = {
      'Breakfast': '🌅',
      'Lunch': '☀️',
      'Dinner': '🌙',
      'Snacks': '🍎'
    };
    return icons[mealType] || '🍽️';
  };

  return (
    <div className="space-y-6">
      {groupedFoods.map(({ mealType, items }) => {
        const mealTotal = items.reduce((sum, item) => sum + item.calories, 0);
        
        return (
          <div key={mealType} className="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl overflow-hidden">
            <div className="bg-gray-50 dark:bg-gray-700/50 px-6 py-4 border-b border-gray-200 dark:border-gray-700">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <span className="text-2xl">{getMealTypeIcon(mealType)}</span>
                  <h3 className="font-semibold text-gray-900 dark:text-white">{mealType}</h3>
                </div>
                {items.length > 0 && (
                  <div className="text-sm">
                    <span className="text-gray-600 dark:text-gray-400">Total: </span>
                    <span className="font-semibold text-emerald-600 dark:text-emerald-400">{mealTotal} cal</span>
                  </div>
                )}
              </div>
            </div>

            <div className="divide-y divide-gray-100 dark:divide-gray-700">
              {items.length === 0 ? (
                <div className="px-6 py-8 text-center text-gray-500 dark:text-gray-400 text-sm">
                  No items logged for {mealType.toLowerCase()}
                </div>
              ) : (
                items.map((food, index) => (
                  <motion.div
                    key={food.id}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: index * 0.05 }}
                    className="px-6 py-4 hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors"
                  >
                    <div className="flex items-start justify-between gap-4">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-1">
                          <h4 className="font-medium text-gray-900 dark:text-white">{food.name}</h4>
                          <span className="text-sm text-gray-500 dark:text-gray-400">({food.serving})</span>
                        </div>
                        <div className="flex items-center gap-2 text-xs text-gray-500 dark:text-gray-400 mb-2">
                          <Clock className="w-3 h-3" />
                          <span>{formatTime(food.timestamp)}</span>
                        </div>
                        <div className="flex gap-4 text-sm">
                          <div>
                            <span className="text-gray-600 dark:text-gray-400">Calories: </span>
                            <span className="font-medium text-gray-900 dark:text-white">{food.calories}</span>
                          </div>
                          <div>
                            <span className="text-gray-600 dark:text-gray-400">P: </span>
                            <span className="font-medium text-emerald-600 dark:text-emerald-400">{food.protein}g</span>
                          </div>
                          <div>
                            <span className="text-gray-600 dark:text-gray-400">C: </span>
                            <span className="font-medium text-blue-600 dark:text-blue-400">{food.carbs}g</span>
                          </div>
                          <div>
                            <span className="text-gray-600 dark:text-gray-400">F: </span>
                            <span className="font-medium text-amber-600 dark:text-amber-400">{food.fat}g</span>
                          </div>
                          {food.fiber > 0 && (
                            <div>
                              <span className="text-gray-600 dark:text-gray-400">Fiber: </span>
                              <span className="font-medium text-purple-600 dark:text-purple-400">{food.fiber}g</span>
                            </div>
                          )}
                        </div>
                      </div>
                      <button
                        onClick={() => onDeleteFood(food.id)}
                        className="p-2 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors group"
                      >
                        <Trash2 className="w-4 h-4 text-gray-400 dark:text-gray-500 group-hover:text-red-600 dark:group-hover:text-red-400" />
                      </button>
                    </div>
                  </motion.div>
                ))
              )}
            </div>
          </div>
        );
      })}
    </div>
  );
}