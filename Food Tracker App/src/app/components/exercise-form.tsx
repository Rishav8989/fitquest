import { Plus, X, Clock, Flame, Dumbbell, Heart } from 'lucide-react';
import { useState } from 'react';

interface Exercise {
  name: string;
  duration: number;
  calories: number;
  type: 'cardio' | 'strength' | 'flexibility' | 'sports';
}

interface ExerciseFormProps {
  onAddExercise: (exercise: Exercise) => void;
  onClose: () => void;
}

export function ExerciseForm({ onAddExercise, onClose }: ExerciseFormProps) {
  const [formData, setFormData] = useState<Exercise>({
    name: '',
    duration: 0,
    calories: 0,
    type: 'cardio'
  });

  const indianExercises = [
    // Yoga & Traditional
    { name: 'Surya Namaskar', duration: 20, calories: 150, type: 'flexibility' as const },
    { name: 'Pranayama', duration: 15, calories: 50, type: 'flexibility' as const },
    { name: 'Yoga Asanas', duration: 45, calories: 180, type: 'flexibility' as const },
    { name: 'Meditation', duration: 20, calories: 40, type: 'flexibility' as const },
    
    // Cardio
    { name: 'Morning Walk', duration: 30, calories: 150, type: 'cardio' as const },
    { name: 'Jogging in Park', duration: 30, calories: 300, type: 'cardio' as const },
    { name: 'Cycling', duration: 40, calories: 280, type: 'cardio' as const },
    { name: 'Skipping Rope', duration: 15, calories: 200, type: 'cardio' as const },
    { name: 'Dance Workout', duration: 30, calories: 220, type: 'cardio' as const },
    
    // Strength
    { name: 'Desi Gym Workout', duration: 45, calories: 250, type: 'strength' as const },
    { name: 'Push-ups & Squats', duration: 20, calories: 120, type: 'strength' as const },
    { name: 'Dumbbell Training', duration: 40, calories: 200, type: 'strength' as const },
    
    // Sports
    { name: 'Cricket', duration: 60, calories: 350, type: 'sports' as const },
    { name: 'Badminton', duration: 45, calories: 320, type: 'sports' as const },
    { name: 'Football', duration: 60, calories: 450, type: 'sports' as const },
    { name: 'Kabaddi', duration: 45, calories: 400, type: 'sports' as const },
    { name: 'Table Tennis', duration: 30, calories: 180, type: 'sports' as const },
    { name: 'Swimming', duration: 30, calories: 350, type: 'sports' as const },
    
    // Daily Activities
    { name: 'Household Chores', duration: 30, calories: 120, type: 'cardio' as const },
    { name: 'Gardening', duration: 30, calories: 150, type: 'cardio' as const },
    { name: 'Stairs Climbing', duration: 15, calories: 140, type: 'cardio' as const },
  ];

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (formData.name && formData.duration > 0) {
      onAddExercise(formData);
      setFormData({ name: '', duration: 0, calories: 0, type: 'cardio' });
    }
  };

  return (
    <div className="fixed inset-0 bg-black/50 flex items-end sm:items-center justify-center z-50">
      <div className="bg-white rounded-t-3xl sm:rounded-3xl w-full sm:max-w-lg max-h-[90vh] overflow-y-auto">
        <div className="sticky top-0 bg-white border-b px-6 py-4 flex items-center justify-between rounded-t-3xl">
          <h2 className="text-lg font-semibold">Add Exercise</h2>
          <button
            onClick={onClose}
            className="p-2 hover:bg-gray-100 rounded-full transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="p-6">
          <div className="mb-6">
            <h3 className="text-sm font-medium text-gray-700 mb-3">🇮🇳 Popular Activities - Quick Add</h3>
            <div className="grid grid-cols-2 gap-2 max-h-[400px] overflow-y-auto pr-2">
              {indianExercises.map((exercise) => (
                <button
                  key={exercise.name}
                  onClick={() => onAddExercise(exercise)}
                  className="p-3 border border-gray-200 rounded-xl hover:border-blue-500 hover:bg-blue-50 transition-all text-left"
                >
                  <div className="font-medium text-sm">{exercise.name}</div>
                  <div className="text-xs text-gray-500">{exercise.duration} min • {exercise.calories} cal</div>
                </button>
              ))}
            </div>
          </div>

          <div className="h-px bg-gray-200 my-6"></div>

          <form onSubmit={handleSubmit}>
            <h3 className="text-sm font-medium text-gray-700 mb-3">Custom Entry</h3>
            
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Exercise Name
                </label>
                <input
                  type="text"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="e.g., Morning Walk"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Type
                </label>
                <div className="grid grid-cols-2 gap-2">
                  {[
                    { value: 'cardio', label: 'Cardio', icon: <Heart className="w-4 h-4" /> },
                    { value: 'strength', label: 'Strength', icon: <Dumbbell className="w-4 h-4" /> },
                    { value: 'flexibility', label: 'Yoga', icon: '🧘' },
                    { value: 'sports', label: 'Sports', icon: '🏏' }
                  ].map((option) => (
                    <button
                      key={option.value}
                      type="button"
                      onClick={() => setFormData({ ...formData, type: option.value as any })}
                      className={`p-3 rounded-xl border-2 transition-all flex items-center gap-2 justify-center ${
                        formData.type === option.value
                          ? 'border-blue-500 bg-blue-50'
                          : 'border-gray-200 hover:border-gray-300'
                      }`}
                    >
                      {typeof option.icon === 'string' ? (
                        <span className="text-lg">{option.icon}</span>
                      ) : (
                        option.icon
                      )}
                      <span className="text-sm font-medium">{option.label}</span>
                    </button>
                  ))}
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Duration (min)
                  </label>
                  <input
                    type="number"
                    value={formData.duration || ''}
                    onChange={(e) => setFormData({ ...formData, duration: parseInt(e.target.value) || 0 })}
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="30"
                    min="0"
                    required
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Calories Burned
                  </label>
                  <input
                    type="number"
                    value={formData.calories || ''}
                    onChange={(e) => setFormData({ ...formData, calories: parseInt(e.target.value) || 0 })}
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="200"
                    min="0"
                  />
                </div>
              </div>
            </div>

            <div className="mt-6 flex gap-3">
              <button
                type="button"
                onClick={onClose}
                className="flex-1 px-4 py-3 border border-gray-300 rounded-xl hover:bg-gray-50 transition-colors font-medium"
              >
                Cancel
              </button>
              <button
                type="submit"
                className="flex-1 px-4 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors flex items-center justify-center gap-2 font-medium"
              >
                <Plus className="w-4 h-4" />
                Add Exercise
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
