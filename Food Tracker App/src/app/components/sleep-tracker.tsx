import { Moon, Sun, CloudMoon } from 'lucide-react';
import { useState } from 'react';

interface SleepTrackerProps {
  sleepData: {
    duration: number;
    quality: 'poor' | 'fair' | 'good' | 'excellent';
    bedtime: string;
    wakeup: string;
  } | null;
  onUpdateSleep: (data: any) => void;
}

export function SleepTracker({ sleepData, onUpdateSleep }: SleepTrackerProps) {
  const [isEditing, setIsEditing] = useState(false);
  const [bedtime, setBedtime] = useState(sleepData?.bedtime || '22:00');
  const [wakeup, setWakeup] = useState(sleepData?.wakeup || '06:00');
  const [quality, setQuality] = useState<'poor' | 'fair' | 'good' | 'excellent'>(
    sleepData?.quality || 'good'
  );

  const calculateDuration = (bedtime: string, wakeup: string) => {
    const [bedHour, bedMin] = bedtime.split(':').map(Number);
    const [wakeHour, wakeMin] = wakeup.split(':').map(Number);
    
    let bedTimeMinutes = bedHour * 60 + bedMin;
    let wakeTimeMinutes = wakeHour * 60 + wakeMin;
    
    if (wakeTimeMinutes < bedTimeMinutes) {
      wakeTimeMinutes += 24 * 60;
    }
    
    return (wakeTimeMinutes - bedTimeMinutes) / 60;
  };

  const duration = calculateDuration(bedtime, wakeup);

  const handleSave = () => {
    onUpdateSleep({
      duration,
      quality,
      bedtime,
      wakeup
    });
    setIsEditing(false);
  };

  const getQualityColor = (q: string) => {
    switch (q) {
      case 'excellent': return 'bg-emerald-500';
      case 'good': return 'bg-blue-500';
      case 'fair': return 'bg-amber-500';
      case 'poor': return 'bg-red-500';
      default: return 'bg-gray-500';
    }
  };

  const getSleepScore = () => {
    let score = 0;
    if (duration >= 7 && duration <= 9) score += 40;
    else if (duration >= 6 && duration < 7) score += 30;
    else if (duration >= 5 && duration < 6) score += 20;
    else score += 10;

    switch (quality) {
      case 'excellent': score += 60; break;
      case 'good': score += 45; break;
      case 'fair': score += 30; break;
      case 'poor': score += 15; break;
    }

    return score;
  };

  const sleepScore = getSleepScore();

  return (
    <div className="bg-white rounded-2xl p-6 border border-gray-200">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-2">
          <Moon className="w-5 h-5 text-indigo-600" />
          <h3 className="font-semibold text-gray-900">Sleep Tracking</h3>
        </div>
        <button
          onClick={() => setIsEditing(!isEditing)}
          className="text-sm text-indigo-600 hover:text-indigo-700 font-medium"
        >
          {isEditing ? 'Cancel' : 'Edit'}
        </button>
      </div>

      {!isEditing ? (
        <div className="space-y-6">
          <div className="text-center">
            <div className="inline-flex items-center justify-center w-24 h-24 rounded-full bg-gradient-to-br from-indigo-500 to-purple-600 text-white mb-4">
              <div>
                <div className="text-3xl font-bold">{sleepScore}</div>
                <div className="text-xs opacity-90">Score</div>
              </div>
            </div>
            <div className="text-2xl font-bold text-gray-900 mb-1">
              {duration.toFixed(1)} hours
            </div>
            <div className="text-sm text-gray-600 capitalize">
              {quality} quality sleep
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="bg-gradient-to-br from-indigo-50 to-purple-50 rounded-xl p-4 text-center">
              <CloudMoon className="w-6 h-6 text-indigo-600 mx-auto mb-2" />
              <div className="text-xs text-gray-600 mb-1">Bedtime</div>
              <div className="font-semibold text-gray-900">{bedtime}</div>
            </div>
            <div className="bg-gradient-to-br from-amber-50 to-orange-50 rounded-xl p-4 text-center">
              <Sun className="w-6 h-6 text-amber-600 mx-auto mb-2" />
              <div className="text-xs text-gray-600 mb-1">Wake Up</div>
              <div className="font-semibold text-gray-900">{wakeup}</div>
            </div>
          </div>

          <div>
            <div className="text-sm text-gray-600 mb-2">Sleep Quality</div>
            <div className="flex gap-2">
              {['poor', 'fair', 'good', 'excellent'].map((q) => (
                <div
                  key={q}
                  className={`flex-1 h-2 rounded-full ${
                    q === quality ? getQualityColor(q) : 'bg-gray-200'
                  }`}
                />
              ))}
            </div>
          </div>

          <div className="bg-blue-50 border border-blue-200 rounded-xl p-4">
            <div className="text-sm font-medium text-blue-900 mb-1">
              💡 Sleep Recommendation
            </div>
            <div className="text-xs text-blue-700">
              {duration < 7
                ? 'Try to get 7-9 hours of sleep for optimal recovery and health.'
                : duration > 9
                ? 'You might be oversleeping. Aim for 7-9 hours for best results.'
                : 'Great! You\'re in the optimal sleep range. Keep it up!'}
            </div>
          </div>
        </div>
      ) : (
        <div className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Bedtime
              </label>
              <input
                type="time"
                value={bedtime}
                onChange={(e) => setBedtime(e.target.value)}
                className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Wake Up
              </label>
              <input
                type="time"
                value={wakeup}
                onChange={(e) => setWakeup(e.target.value)}
                className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-3">
              Sleep Quality
            </label>
            <div className="grid grid-cols-4 gap-2">
              {(['poor', 'fair', 'good', 'excellent'] as const).map((q) => (
                <button
                  key={q}
                  onClick={() => setQuality(q)}
                  className={`py-3 rounded-xl border-2 transition-all capitalize text-sm font-medium ${
                    quality === q
                      ? 'border-indigo-500 bg-indigo-50 text-indigo-700'
                      : 'border-gray-200 hover:border-gray-300 text-gray-700'
                  }`}
                >
                  {q}
                </button>
              ))}
            </div>
          </div>

          <button
            onClick={handleSave}
            className="w-full px-4 py-3 bg-indigo-600 text-white rounded-xl hover:bg-indigo-700 transition-colors font-medium"
          >
            Save Sleep Data
          </button>
        </div>
      )}
    </div>
  );
}
