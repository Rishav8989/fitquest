import { Trophy, Flame, Target, Star, Award, Zap } from 'lucide-react';
import { motion } from 'motion/react';

interface GamificationPanelProps {
  points: number;
  level: number;
  streak: number;
  achievements: Achievement[];
}

interface Achievement {
  id: string;
  title: string;
  description: string;
  icon: string;
  unlocked: boolean;
  unlockedDate?: string;
}

export function GamificationPanel({ points, level, streak, achievements }: GamificationPanelProps) {
  const pointsToNextLevel = (level + 1) * 100;
  const currentLevelPoints = points % 100;
  const progress = (currentLevelPoints / pointsToNextLevel) * 100;

  const unlockedAchievements = achievements.filter(a => a.unlocked);

  return (
    <div className="space-y-6">
      <div className="bg-gradient-to-br from-emerald-500 to-teal-600 rounded-2xl p-6 text-white">
        <div className="flex items-center justify-between mb-4">
          <div>
            <div className="text-sm opacity-90 mb-1">Your Level</div>
            <div className="text-4xl font-bold">Level {level}</div>
          </div>
          <div className="bg-white/20 backdrop-blur-sm rounded-full p-4">
            <Trophy className="w-8 h-8" />
          </div>
        </div>

        <div className="mb-2">
          <div className="flex items-center justify-between text-sm mb-1">
            <span>{currentLevelPoints} XP</span>
            <span>{pointsToNextLevel} XP</span>
          </div>
          <div className="h-3 bg-white/20 rounded-full overflow-hidden">
            <motion.div
              initial={{ width: 0 }}
              animate={{ width: `${progress}%` }}
              transition={{ duration: 0.5, ease: "easeOut" }}
              className="h-full bg-white rounded-full"
            />
          </div>
        </div>
        <div className="text-sm opacity-90">
          {pointsToNextLevel - currentLevelPoints} XP to next level
        </div>
      </div>

      <div className="grid grid-cols-2 gap-4">
        <div className="bg-white border border-gray-200 rounded-xl p-4">
          <div className="flex items-center gap-3 mb-2">
            <div className="bg-orange-100 rounded-full p-2">
              <Flame className="w-5 h-5 text-orange-600" />
            </div>
            <div>
              <div className="text-sm text-gray-600">Streak</div>
              <div className="text-2xl font-bold text-gray-900">{streak}</div>
            </div>
          </div>
          <div className="text-xs text-gray-500">days in a row</div>
        </div>

        <div className="bg-white border border-gray-200 rounded-xl p-4">
          <div className="flex items-center gap-3 mb-2">
            <div className="bg-purple-100 rounded-full p-2">
              <Star className="w-5 h-5 text-purple-600" />
            </div>
            <div>
              <div className="text-sm text-gray-600">Points</div>
              <div className="text-2xl font-bold text-gray-900">{points}</div>
            </div>
          </div>
          <div className="text-xs text-gray-500">total earned</div>
        </div>
      </div>

      <div className="bg-white border border-gray-200 rounded-xl p-6">
        <div className="flex items-center gap-2 mb-4">
          <Award className="w-5 h-5 text-amber-600" />
          <h3 className="font-semibold text-gray-900">Achievements</h3>
          <span className="ml-auto text-sm text-gray-500">
            {unlockedAchievements.length}/{achievements.length}
          </span>
        </div>

        <div className="space-y-3">
          {achievements.slice(0, 5).map((achievement) => (
            <motion.div
              key={achievement.id}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              className={`flex items-center gap-3 p-3 rounded-lg ${
                achievement.unlocked
                  ? 'bg-amber-50 border border-amber-200'
                  : 'bg-gray-50 border border-gray-200'
              }`}
            >
              <div
                className={`text-2xl ${
                  achievement.unlocked ? 'grayscale-0' : 'grayscale opacity-50'
                }`}
              >
                {achievement.icon}
              </div>
              <div className="flex-1">
                <div className={`font-medium text-sm ${
                  achievement.unlocked ? 'text-gray-900' : 'text-gray-500'
                }`}>
                  {achievement.title}
                </div>
                <div className="text-xs text-gray-500">{achievement.description}</div>
              </div>
              {achievement.unlocked && (
                <Zap className="w-4 h-4 text-amber-600" />
              )}
            </motion.div>
          ))}
        </div>
      </div>

      <div className="bg-gradient-to-br from-blue-50 to-indigo-50 border border-blue-200 rounded-xl p-4">
        <div className="flex items-center gap-3">
          <Target className="w-6 h-6 text-blue-600" />
          <div>
            <div className="font-medium text-gray-900">Daily Challenge</div>
            <div className="text-sm text-gray-600">Log 3 meals today for +50 XP</div>
          </div>
        </div>
        <div className="mt-3 h-2 bg-white rounded-full overflow-hidden">
          <div className="h-full bg-blue-600 rounded-full" style={{ width: '66%' }} />
        </div>
        <div className="text-xs text-gray-600 mt-1">2/3 meals logged</div>
      </div>
    </div>
  );
}
