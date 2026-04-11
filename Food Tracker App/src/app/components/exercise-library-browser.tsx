import { useState } from 'react';
import { Search, X, Dumbbell, Home, Flame, Heart, Zap, Trophy, ArrowRight, ChevronDown, ChevronUp } from 'lucide-react';
import { exerciseLibrary, Exercise, searchExercises, getExercisesByCategory } from '../utils/exercise-library';

interface ExerciseLibraryBrowserProps {
  isOpen: boolean;
  onClose: () => void;
  onSelectExercise?: (exercise: Exercise) => void;
}

export function ExerciseLibraryBrowser({ isOpen, onClose, onSelectExercise }: ExerciseLibraryBrowserProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string>('all');
  const [selectedDifficulty, setSelectedDifficulty] = useState<string>('all');
  const [expandedExercise, setExpandedExercise] = useState<string | null>(null);

  if (!isOpen) return null;

  const categories = [
    { id: 'all', name: 'All', icon: Trophy, color: 'orange' },
    { id: 'gym', name: 'Gym', icon: Dumbbell, color: 'blue' },
    { id: 'home', name: 'Home', icon: Home, color: 'green' },
    { id: 'yoga', name: 'Yoga', icon: Heart, color: 'purple' },
    { id: 'cardio', name: 'Cardio', icon: Flame, color: 'red' },
    { id: 'hiit', name: 'HIIT', icon: Zap, color: 'yellow' },
    { id: 'sports', name: 'Sports', icon: Trophy, color: 'indigo' },
  ];

  // Filter exercises
  let filteredExercises = exerciseLibrary;
  
  if (searchQuery) {
    filteredExercises = searchExercises(searchQuery);
  }
  
  if (selectedCategory !== 'all') {
    filteredExercises = filteredExercises.filter(ex => ex.category === selectedCategory);
  }
  
  if (selectedDifficulty !== 'all') {
    filteredExercises = filteredExercises.filter(ex => ex.difficulty === selectedDifficulty);
  }

  const getDifficultyColor = (difficulty: string) => {
    switch (difficulty) {
      case 'beginner': return 'text-green-600 dark:text-green-400 bg-green-50 dark:bg-green-900/30';
      case 'intermediate': return 'text-yellow-600 dark:text-yellow-400 bg-yellow-50 dark:bg-yellow-900/30';
      case 'advanced': return 'text-red-600 dark:text-red-400 bg-red-50 dark:bg-red-900/30';
      default: return 'text-gray-600 dark:text-gray-400 bg-gray-50 dark:bg-gray-900/30';
    }
  };

  return (
    <div className="fixed inset-0 bg-black/60 z-50 flex items-center justify-center p-4 backdrop-blur-sm overflow-y-auto">
      <div className="bg-white dark:bg-gray-800 rounded-3xl max-w-4xl w-full my-8 shadow-2xl border border-gray-200 dark:border-gray-700 max-h-[90vh] flex flex-col">
        {/* Header */}
        <div className="bg-gradient-to-r from-orange-500 to-amber-600 dark:from-orange-600 dark:to-amber-700 p-6 text-white rounded-t-3xl">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h2 className="text-2xl font-bold flex items-center gap-2">
                <Dumbbell className="w-6 h-6" />
                Exercise Library
              </h2>
              <p className="text-sm text-white/90 mt-1">200+ exercises from gym to yoga</p>
            </div>
            <button 
              onClick={onClose}
              className="p-2 hover:bg-white/20 rounded-full transition-colors"
            >
              <X className="w-6 h-6" />
            </button>
          </div>

          {/* Search */}
          <div className="relative">
            <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search exercises..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-12 pr-4 py-3 bg-white/20 backdrop-blur-sm border border-white/30 rounded-xl text-white placeholder-white/70 focus:outline-none focus:ring-2 focus:ring-white/50"
            />
          </div>
        </div>

        {/* Filters */}
        <div className="p-4 bg-gray-50 dark:bg-gray-900/50 border-b border-gray-200 dark:border-gray-700">
          {/* Category Pills */}
          <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
            {categories.map((cat) => {
              const Icon = cat.icon;
              return (
                <button
                  key={cat.id}
                  onClick={() => setSelectedCategory(cat.id)}
                  className={`flex items-center gap-2 px-4 py-2 rounded-full font-medium text-sm whitespace-nowrap transition-all ${
                    selectedCategory === cat.id
                      ? 'bg-orange-500 text-white shadow-lg scale-105'
                      : 'bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 border border-gray-200 dark:border-gray-600'
                  }`}
                >
                  <Icon className="w-4 h-4" />
                  {cat.name}
                </button>
              );
            })}
          </div>

          {/* Difficulty Filter */}
          <div className="flex gap-2 mt-3">
            {[
              { id: 'all', name: 'All Levels' },
              { id: 'beginner', name: 'Beginner' },
              { id: 'intermediate', name: 'Intermediate' },
              { id: 'advanced', name: 'Advanced' }
            ].map((diff) => (
              <button
                key={diff.id}
                onClick={() => setSelectedDifficulty(diff.id)}
                className={`px-4 py-1.5 rounded-full text-xs font-medium transition-all ${
                  selectedDifficulty === diff.id
                    ? 'bg-purple-500 text-white shadow-md'
                    : 'bg-white dark:bg-gray-800 text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700 border border-gray-200 dark:border-gray-600'
                }`}
              >
                {diff.name}
              </button>
            ))}
          </div>

          <div className="mt-3 text-sm text-gray-600 dark:text-gray-400">
            Showing {filteredExercises.length} exercises
          </div>
        </div>

        {/* Exercise List */}
        <div className="flex-1 overflow-y-auto p-4 space-y-3">
          {filteredExercises.map((exercise) => {
            const isExpanded = expandedExercise === exercise.id;
            return (
              <div
                key={exercise.id}
                className="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-2xl overflow-hidden hover:shadow-lg transition-all cursor-pointer"
              >
                <div
                  onClick={() => setExpandedExercise(isExpanded ? null : exercise.id)}
                  className="p-4"
                >
                  <div className="flex items-start justify-between gap-3">
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-2">
                        <h3 className="font-semibold text-gray-900 dark:text-white">
                          {exercise.name}
                        </h3>
                        <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${getDifficultyColor(exercise.difficulty)}`}>
                          {exercise.difficulty}
                        </span>
                      </div>
                      <p className="text-sm text-gray-600 dark:text-gray-400 mb-2">
                        {exercise.description}
                      </p>
                      <div className="flex flex-wrap gap-2">
                        {exercise.muscleGroups.map((muscle, idx) => (
                          <span
                            key={idx}
                            className="px-2 py-1 bg-blue-50 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 rounded-lg text-xs font-medium"
                          >
                            {muscle}
                          </span>
                        ))}
                      </div>
                    </div>
                    <div className="text-right">
                      <div className="text-sm font-semibold text-orange-600 dark:text-orange-400">
                        {exercise.caloriesPerMinute} cal/min
                      </div>
                      {isExpanded ? (
                        <ChevronUp className="w-5 h-5 text-gray-400 mt-2" />
                      ) : (
                        <ChevronDown className="w-5 h-5 text-gray-400 mt-2" />
                      )}
                    </div>
                  </div>

                  {isExpanded && (
                    <div className="mt-4 pt-4 border-t border-gray-200 dark:border-gray-700 space-y-4">
                      {/* Instructions */}
                      <div>
                        <h4 className="font-semibold text-gray-900 dark:text-white mb-2 text-sm">
                          Instructions:
                        </h4>
                        <ol className="space-y-1.5 text-sm text-gray-600 dark:text-gray-400 ml-4">
                          {exercise.instructions.map((instruction, idx) => (
                            <li key={idx} className="flex gap-2">
                              <span className="font-medium text-orange-600 dark:text-orange-400">
                                {idx + 1}.
                              </span>
                              <span>{instruction}</span>
                            </li>
                          ))}
                        </ol>
                      </div>

                      {/* Tips */}
                      <div>
                        <h4 className="font-semibold text-gray-900 dark:text-white mb-2 text-sm">
                          Pro Tips:
                        </h4>
                        <ul className="space-y-1.5 text-sm text-gray-600 dark:text-gray-400">
                          {exercise.tips.map((tip, idx) => (
                            <li key={idx} className="flex gap-2">
                              <span className="text-green-500">✓</span>
                              <span>{tip}</span>
                            </li>
                          ))}
                        </ul>
                      </div>

                      {/* Details */}
                      <div className="grid grid-cols-2 gap-3">
                        {exercise.sets && (
                          <div className="bg-gray-50 dark:bg-gray-900/50 p-3 rounded-xl">
                            <div className="text-xs text-gray-500 dark:text-gray-500">Sets</div>
                            <div className="font-semibold text-gray-900 dark:text-white">
                              {exercise.sets}
                            </div>
                          </div>
                        )}
                        {exercise.reps && (
                          <div className="bg-gray-50 dark:bg-gray-900/50 p-3 rounded-xl">
                            <div className="text-xs text-gray-500 dark:text-gray-500">Reps</div>
                            <div className="font-semibold text-gray-900 dark:text-white">
                              {exercise.reps}
                            </div>
                          </div>
                        )}
                        {exercise.duration && (
                          <div className="bg-gray-50 dark:bg-gray-900/50 p-3 rounded-xl">
                            <div className="text-xs text-gray-500 dark:text-gray-500">Duration</div>
                            <div className="font-semibold text-gray-900 dark:text-white">
                              {exercise.duration}s
                            </div>
                          </div>
                        )}
                        {exercise.equipment.length > 0 && (
                          <div className="bg-gray-50 dark:bg-gray-900/50 p-3 rounded-xl col-span-2">
                            <div className="text-xs text-gray-500 dark:text-gray-500 mb-1">
                              Equipment
                            </div>
                            <div className="flex flex-wrap gap-1">
                              {exercise.equipment.map((eq, idx) => (
                                <span
                                  key={idx}
                                  className="text-xs bg-purple-100 dark:bg-purple-900/30 text-purple-700 dark:text-purple-400 px-2 py-0.5 rounded-full"
                                >
                                  {eq}
                                </span>
                              ))}
                            </div>
                          </div>
                        )}
                      </div>

                      {onSelectExercise && (
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            onSelectExercise(exercise);
                            onClose();
                          }}
                          className="w-full py-3 bg-gradient-to-r from-orange-500 to-amber-600 hover:from-orange-600 hover:to-amber-700 text-white font-semibold rounded-xl flex items-center justify-center gap-2 shadow-md hover:shadow-lg transition-all"
                        >
                          Add to Workout
                          <ArrowRight className="w-5 h-5" />
                        </button>
                      )}
                    </div>
                  )}
                </div>
              </div>
            );
          })}

          {filteredExercises.length === 0 && (
            <div className="text-center py-12">
              <Dumbbell className="w-16 h-16 mx-auto text-gray-300 dark:text-gray-600 mb-4" />
              <p className="text-gray-500 dark:text-gray-400">
                No exercises found. Try adjusting your filters.
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
