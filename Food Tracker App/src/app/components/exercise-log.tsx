import { Trash2, Clock, Dumbbell, Heart, Flame } from 'lucide-react';
import { motion } from 'motion/react';

interface ExerciseEntry {
  id: string;
  name: string;
  duration: number;
  calories: number;
  type: 'cardio' | 'strength' | 'flexibility' | 'sports';
  timestamp: Date;
}

interface ExerciseLogProps {
  exercises: ExerciseEntry[];
  onDeleteExercise: (id: string) => void;
}

export function ExerciseLog({ exercises, onDeleteExercise }: ExerciseLogProps) {
  const formatTime = (date: Date) => {
    return new Date(date).toLocaleTimeString('en-US', { 
      hour: 'numeric', 
      minute: '2-digit',
      hour12: true 
    });
  };

  const getTypeIcon = (type: string) => {
    switch (type) {
      case 'cardio': return <Heart className="w-4 h-4" />;
      case 'strength': return <Dumbbell className="w-4 h-4" />;
      case 'flexibility': return '🧘';
      case 'sports': return '⚽';
      default: return '💪';
    }
  };

  const getTypeColor = (type: string) => {
    switch (type) {
      case 'cardio': return 'bg-red-50 text-red-700 border-red-200';
      case 'strength': return 'bg-blue-50 text-blue-700 border-blue-200';
      case 'flexibility': return 'bg-purple-50 text-purple-700 border-purple-200';
      case 'sports': return 'bg-green-50 text-green-700 border-green-200';
      default: return 'bg-gray-50 text-gray-700 border-gray-200';
    }
  };

  const totalDuration = exercises.reduce((sum, ex) => sum + ex.duration, 0);
  const totalCalories = exercises.reduce((sum, ex) => sum + ex.calories, 0);

  return (
    <div className="space-y-4">
      {exercises.length > 0 && (
        <div className="bg-gradient-to-br from-blue-500 to-cyan-600 rounded-2xl p-6 text-white">
          <div className="text-sm opacity-90 mb-2">Today's Activity</div>
          <div className="grid grid-cols-2 gap-4">
            <div>
              <div className="text-3xl font-bold mb-1">{totalDuration}</div>
              <div className="text-sm opacity-90">minutes</div>
            </div>
            <div>
              <div className="text-3xl font-bold mb-1">{totalCalories}</div>
              <div className="text-sm opacity-90">calories burned</div>
            </div>
          </div>
        </div>
      )}

      <div className="bg-white border border-gray-200 rounded-2xl overflow-hidden">
        {exercises.length === 0 ? (
          <div className="px-6 py-12 text-center">
            <div className="text-6xl mb-4">🏃</div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">No exercises logged yet</h3>
            <p className="text-sm text-gray-500">Start tracking your workouts to see your progress!</p>
          </div>
        ) : (
          <div className="divide-y divide-gray-100">
            {exercises.map((exercise, index) => (
              <motion.div
                key={exercise.id}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: index * 0.05 }}
                className="px-6 py-4 hover:bg-gray-50 transition-colors"
              >
                <div className="flex items-start justify-between gap-4">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-2">
                      <h4 className="font-medium text-gray-900">{exercise.name}</h4>
                      <span className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-xs font-medium border ${getTypeColor(exercise.type)}`}>
                        {typeof getTypeIcon(exercise.type) === 'string' ? (
                          <span>{getTypeIcon(exercise.type)}</span>
                        ) : (
                          getTypeIcon(exercise.type)
                        )}
                        {exercise.type}
                      </span>
                    </div>
                    <div className="flex items-center gap-2 text-xs text-gray-500 mb-3">
                      <Clock className="w-3 h-3" />
                      <span>{formatTime(exercise.timestamp)}</span>
                    </div>
                    <div className="flex gap-4">
                      <div className="flex items-center gap-1.5 text-sm">
                        <Clock className="w-4 h-4 text-blue-600" />
                        <span className="text-gray-600">Duration:</span>
                        <span className="font-medium text-gray-900">{exercise.duration} min</span>
                      </div>
                      <div className="flex items-center gap-1.5 text-sm">
                        <Flame className="w-4 h-4 text-orange-600" />
                        <span className="text-gray-600">Burned:</span>
                        <span className="font-medium text-gray-900">{exercise.calories} cal</span>
                      </div>
                    </div>
                  </div>
                  <button
                    onClick={() => onDeleteExercise(exercise.id)}
                    className="p-2 hover:bg-red-50 rounded-lg transition-colors group"
                  >
                    <Trash2 className="w-4 h-4 text-gray-400 group-hover:text-red-600" />
                  </button>
                </div>
              </motion.div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
