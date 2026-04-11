import { useState } from 'react';
import { Plus, X } from 'lucide-react';

interface FoodEntry {
  name: string;
  calories: number;
  protein: number;
  carbs: number;
  fat: number;
  fiber: number;
  serving: string;
}

interface FoodEntryFormProps {
  onAddFood: (food: FoodEntry) => void;
  onClose: () => void;
}

export function FoodEntryForm({ onAddFood, onClose }: FoodEntryFormProps) {
  const [formData, setFormData] = useState<FoodEntry>({
    name: '',
    calories: 0,
    protein: 0,
    carbs: 0,
    fat: 0,
    fiber: 0,
    serving: '1 serving'
  });

  const indianMeals = [
    // Breakfast
    { name: 'Idli (2 pcs)', calories: 78, protein: 2, carbs: 17, fat: 0.2, fiber: 0.8, serving: '2 pieces' },
    { name: 'Dosa with Sambar', calories: 168, protein: 4, carbs: 28, fat: 4, fiber: 2, serving: '1 dosa' },
    { name: 'Poha', calories: 250, protein: 6, carbs: 45, fat: 6, fiber: 3, serving: '1 bowl' },
    { name: 'Upma', calories: 200, protein: 5, carbs: 38, fat: 4, fiber: 2.5, serving: '1 bowl' },
    { name: 'Paratha with Curd', calories: 320, protein: 8, carbs: 42, fat: 14, fiber: 3, serving: '1 paratha' },
    { name: 'Aloo Paratha', calories: 350, protein: 7, carbs: 48, fat: 15, fiber: 4, serving: '1 paratha' },
    
    // Lunch/Dinner
    { name: 'Dal Rice', calories: 320, protein: 12, carbs: 58, fat: 4, fiber: 6, serving: '1 plate' },
    { name: 'Rajma Chawal', calories: 380, protein: 15, carbs: 65, fat: 5, fiber: 8, serving: '1 plate' },
    { name: 'Chole Bhature', calories: 550, protein: 16, carbs: 78, fat: 18, fiber: 9, serving: '2 bhature' },
    { name: 'Paneer Tikka', calories: 280, protein: 18, carbs: 8, fat: 20, fiber: 2, serving: '6 pieces' },
    { name: 'Chicken Curry', calories: 245, protein: 28, carbs: 6, fat: 12, fiber: 1.5, serving: '1 bowl' },
    { name: 'Fish Curry', calories: 220, protein: 26, carbs: 5, fat: 11, fiber: 1, serving: '1 bowl' },
    { name: 'Biryani (Chicken)', calories: 450, protein: 22, carbs: 55, fat: 16, fiber: 3, serving: '1 plate' },
    { name: 'Roti with Sabzi', calories: 280, protein: 8, carbs: 48, fat: 6, fiber: 5, serving: '2 roti' },
    { name: 'Khichdi', calories: 220, protein: 8, carbs: 42, fat: 3, fiber: 4, serving: '1 bowl' },
    
    // Snacks
    { name: 'Samosa (1 pc)', calories: 252, protein: 5, carbs: 30, fat: 13, fiber: 3, serving: '1 piece' },
    { name: 'Pakora', calories: 180, protein: 4, carbs: 22, fat: 9, fiber: 2, serving: '4 pieces' },
    { name: 'Dhokla', calories: 160, protein: 4, carbs: 32, fat: 2, fiber: 2, serving: '4 pieces' },
    { name: 'Vada Pav', calories: 290, protein: 7, carbs: 42, fat: 11, fiber: 3, serving: '1 piece' },
    { name: 'Chana Chaat', calories: 200, protein: 9, carbs: 32, fat: 4, fiber: 7, serving: '1 bowl' },
    { name: 'Fruit Chaat', calories: 120, protein: 2, carbs: 28, fat: 1, fiber: 4, serving: '1 bowl' },
    
    // Common Items
    { name: 'Chapati/Roti', calories: 71, protein: 3, carbs: 15, fat: 0.4, fiber: 2.7, serving: '1 piece' },
    { name: 'Brown Rice', calories: 112, protein: 2.6, carbs: 24, fat: 0.9, fiber: 1.8, serving: '100g' },
    { name: 'Curd/Dahi', calories: 60, protein: 3.5, carbs: 4.7, fat: 3.3, fiber: 0, serving: '100g' },
    { name: 'Paneer', calories: 265, protein: 18, carbs: 3.6, fat: 20, fiber: 0, serving: '100g' },
    { name: 'Egg Bhurji', calories: 195, protein: 14, carbs: 4, fat: 14, fiber: 1, serving: '2 eggs' },
    { name: 'Moong Dal', calories: 104, protein: 7, carbs: 19, fat: 0.4, fiber: 5, serving: '100g' },
  ];

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (formData.name && formData.calories > 0) {
      onAddFood(formData);
      setFormData({
        name: '',
        calories: 0,
        protein: 0,
        carbs: 0,
        fat: 0,
        fiber: 0,
        serving: '1 serving'
      });
    }
  };

  return (
    <div className="fixed inset-0 bg-black/50 flex items-end sm:items-center justify-center z-50">
      <div className="bg-white rounded-t-3xl sm:rounded-3xl w-full sm:max-w-2xl max-h-[90vh] overflow-y-auto">
        <div className="sticky top-0 bg-white border-b px-6 py-4 flex items-center justify-between rounded-t-3xl">
          <h2 className="text-lg font-semibold">Add Food Entry</h2>
          <button
            onClick={onClose}
            className="p-2 hover:bg-gray-100 rounded-full transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="p-6">
          <div className="mb-6">
            <h3 className="text-sm font-medium text-gray-700 mb-3">🇮🇳 Indian Meals - Quick Add</h3>
            <div className="grid grid-cols-2 gap-2 max-h-[400px] overflow-y-auto pr-2">
              {indianMeals.map((item) => (
                <button
                  key={item.name}
                  onClick={() => onAddFood(item)}
                  className="p-3 border border-gray-200 rounded-xl hover:border-orange-500 hover:bg-orange-50 transition-all text-left"
                >
                  <div className="font-medium text-sm">{item.name}</div>
                  <div className="text-xs text-gray-500">{item.calories} cal</div>
                </button>
              ))}
            </div>
          </div>

          <div className="h-px bg-gray-200 my-6"></div>

          <form onSubmit={handleSubmit}>
            <h3 className="text-sm font-medium text-gray-700 mb-3">Custom Entry</h3>
            
            <div className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Food Name
                  </label>
                  <input
                    type="text"
                    value={formData.name}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500"
                    placeholder="e.g., Palak Paneer"
                    required
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Serving Size
                  </label>
                  <input
                    type="text"
                    value={formData.serving}
                    onChange={(e) => setFormData({ ...formData, serving: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500"
                    placeholder="e.g., 1 bowl"
                  />
                </div>
              </div>

              <div className="grid grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Calories
                  </label>
                  <input
                    type="number"
                    value={formData.calories || ''}
                    onChange={(e) => setFormData({ ...formData, calories: parseFloat(e.target.value) || 0 })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500"
                    placeholder="0"
                    min="0"
                    required
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Protein (g)
                  </label>
                  <input
                    type="number"
                    value={formData.protein || ''}
                    onChange={(e) => setFormData({ ...formData, protein: parseFloat(e.target.value) || 0 })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500"
                    placeholder="0"
                    min="0"
                    step="0.1"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Carbs (g)
                  </label>
                  <input
                    type="number"
                    value={formData.carbs || ''}
                    onChange={(e) => setFormData({ ...formData, carbs: parseFloat(e.target.value) || 0 })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500"
                    placeholder="0"
                    min="0"
                    step="0.1"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Fat (g)
                  </label>
                  <input
                    type="number"
                    value={formData.fat || ''}
                    onChange={(e) => setFormData({ ...formData, fat: parseFloat(e.target.value) || 0 })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500"
                    placeholder="0"
                    min="0"
                    step="0.1"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Fiber (g)
                  </label>
                  <input
                    type="number"
                    value={formData.fiber || ''}
                    onChange={(e) => setFormData({ ...formData, fiber: parseFloat(e.target.value) || 0 })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500"
                    placeholder="0"
                    min="0"
                    step="0.1"
                  />
                </div>
              </div>
            </div>

            <div className="mt-6 flex gap-3">
              <button
                type="button"
                onClick={onClose}
                className="flex-1 px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
              >
                Cancel
              </button>
              <button
                type="submit"
                className="flex-1 px-4 py-2 bg-orange-600 text-white rounded-lg hover:bg-orange-700 transition-colors flex items-center justify-center gap-2"
              >
                <Plus className="w-4 h-4" />
                Add Food
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
