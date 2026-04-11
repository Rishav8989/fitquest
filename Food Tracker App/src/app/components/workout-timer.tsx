import { useState, useEffect } from 'react';
import { Play, Pause, RotateCcw, X, Plus, Minus, Clock, Timer, Zap } from 'lucide-react';

interface WorkoutTimerProps {
  isOpen: boolean;
  onClose: () => void;
  mode?: 'stopwatch' | 'timer' | 'interval' | 'rest';
}

export function WorkoutTimer({ isOpen, onClose, mode: initialMode = 'stopwatch' }: WorkoutTimerProps) {
  const [mode, setMode] = useState<'stopwatch' | 'timer' | 'interval' | 'rest'>(initialMode);
  const [time, setTime] = useState(0);
  const [targetTime, setTargetTime] = useState(60);
  const [isRunning, setIsRunning] = useState(false);
  
  // Interval timer state
  const [workTime, setWorkTime] = useState(30);
  const [restTime, setRestTime] = useState(15);
  const [rounds, setRounds] = useState(8);
  const [currentRound, setCurrentRound] = useState(1);
  const [isWorkPhase, setIsWorkPhase] = useState(true);
  const [intervalTime, setIntervalTime] = useState(30);

  useEffect(() => {
    let interval: any;
    if (isRunning) {
      interval = setInterval(() => {
        if (mode === 'stopwatch') {
          setTime(prev => prev + 1);
        } else if (mode === 'timer') {
          setTime(prev => {
            if (prev <= 1) {
              setIsRunning(false);
              playBeep();
              return 0;
            }
            return prev - 1;
          });
        } else if (mode === 'rest') {
          setTime(prev => {
            if (prev <= 1) {
              setIsRunning(false);
              playBeep();
              return 0;
            }
            return prev - 1;
          });
        } else if (mode === 'interval') {
          setIntervalTime(prev => {
            if (prev <= 1) {
              if (isWorkPhase) {
                // Switch to rest
                setIsWorkPhase(false);
                return restTime;
              } else {
                // Switch to work or end round
                if (currentRound >= rounds) {
                  setIsRunning(false);
                  playBeep();
                  return 0;
                } else {
                  setCurrentRound(r => r + 1);
                  setIsWorkPhase(true);
                  return workTime;
                }
              }
            }
            return prev - 1;
          });
        }
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [isRunning, mode, isWorkPhase, currentRound, rounds, workTime, restTime]);

  const playBeep = () => {
    // Simple beep simulation
    try {
      const audio = new Audio('data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdJivrJBhNjVgodDbq2EcBj+a2/LDciUFLIHO8tiJNwgZaLvt559NEAxQp+PwtmMcBjiR1/LMeSwFJHfH8N2QQAoUXrTp66hVFApGn+DyvmwhBSuBzvLZiTYIGmi77eeeTBENUKfk77ZiHAY4ktfyzHksBSR3x/DdkUALFGC16OumUxQKRp/g8r5sIQUrgs/y2Yk1CBpou+3nn0wRDVCn5O+2YhwGOJLX8sx5KwUkd8fw3ZFAC');
      audio.play();
    } catch (e) {
      // Silent fail
    }
  };

  const formatTime = (seconds: number) => {
    const hrs = Math.floor(seconds / 3600);
    const mins = Math.floor((seconds % 3600) / 60);
    const secs = seconds % 60;
    if (hrs > 0) {
      return `${hrs.toString().padStart(2, '0')}:${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
    }
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  const handleReset = () => {
    setIsRunning(false);
    setTime(0);
    setIntervalTime(workTime);
    setCurrentRound(1);
    setIsWorkPhase(true);
  };

  const handleStartPause = () => {
    if (!isRunning && time === 0 && mode === 'timer') {
      setTime(targetTime);
    }
    if (!isRunning && intervalTime === 0 && mode === 'interval') {
      setIntervalTime(workTime);
    }
    if (!isRunning && time === 0 && mode === 'rest') {
      setTime(targetTime);
    }
    setIsRunning(!isRunning);
  };

  if (!isOpen) return null;

  const displayTime = mode === 'interval' ? intervalTime : time;

  return (
    <div className="fixed inset-0 bg-black/60 z-50 flex items-center justify-center p-4 backdrop-blur-sm">
      <div className="bg-white dark:bg-gray-800 rounded-3xl max-w-md w-full shadow-2xl border border-gray-200 dark:border-gray-700 overflow-hidden">
        {/* Header */}
        <div className="bg-gradient-to-r from-orange-500 to-amber-600 dark:from-orange-600 dark:to-amber-700 p-6 text-white">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-2xl font-bold flex items-center gap-2">
              <Zap className="w-6 h-6" />
              Workout Timer
            </h2>
            <button 
              onClick={onClose}
              className="p-2 hover:bg-white/20 rounded-full transition-colors"
            >
              <X className="w-6 h-6" />
            </button>
          </div>

          {/* Mode Selector */}
          <div className="grid grid-cols-4 gap-2">
            {[
              { id: 'stopwatch', icon: Clock, label: 'Stopwatch' },
              { id: 'timer', icon: Timer, label: 'Timer' },
              { id: 'interval', icon: Zap, label: 'Interval' },
              { id: 'rest', icon: Clock, label: 'Rest' }
            ].map((m) => {
              const Icon = m.icon;
              return (
                <button
                  key={m.id}
                  onClick={() => { handleReset(); setMode(m.id as any); }}
                  className={`py-3 px-2 rounded-xl font-medium text-sm transition-all ${
                    mode === m.id
                      ? 'bg-white text-orange-600 shadow-lg'
                      : 'bg-white/20 hover:bg-white/30'
                  }`}
                >
                  <Icon className="w-5 h-5 mx-auto mb-1" />
                  {m.label}
                </button>
              );
            })}
          </div>
        </div>

        {/* Timer Display */}
        <div className="p-8">
          <div className="text-center mb-8">
            <div className={`text-7xl font-bold mb-4 tabular-nums transition-colors ${
              mode === 'interval' && !isWorkPhase 
                ? 'text-blue-600 dark:text-blue-400' 
                : 'text-gray-900 dark:text-white'
            }`}>
              {formatTime(displayTime)}
            </div>
            
            {mode === 'interval' && (
              <div className="space-y-2">
                <div className={`text-lg font-semibold ${
                  isWorkPhase 
                    ? 'text-green-600 dark:text-green-400' 
                    : 'text-blue-600 dark:text-blue-400'
                }`}>
                  {isWorkPhase ? '🔥 WORK' : '💧 REST'}
                </div>
                <div className="text-sm text-gray-600 dark:text-gray-400">
                  Round {currentRound} / {rounds}
                </div>
                <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2">
                  <div 
                    className="bg-gradient-to-r from-orange-500 to-amber-600 h-2 rounded-full transition-all"
                    style={{ width: `${(currentRound / rounds) * 100}%` }}
                  />
                </div>
              </div>
            )}
          </div>

          {/* Controls based on mode */}
          {!isRunning && time === 0 && mode === 'timer' && (
            <div className="mb-6">
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Set Duration (seconds)
              </label>
              <div className="flex items-center gap-3">
                <button
                  onClick={() => setTargetTime(Math.max(10, targetTime - 10))}
                  className="p-3 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 rounded-xl transition-colors"
                >
                  <Minus className="w-5 h-5 text-gray-700 dark:text-gray-300" />
                </button>
                <input
                  type="number"
                  value={targetTime}
                  onChange={(e) => setTargetTime(Math.max(1, parseInt(e.target.value) || 1))}
                  className="flex-1 px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-center text-lg font-semibold text-gray-900 dark:text-white focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                />
                <button
                  onClick={() => setTargetTime(targetTime + 10)}
                  className="p-3 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 rounded-xl transition-colors"
                >
                  <Plus className="w-5 h-5 text-gray-700 dark:text-gray-300" />
                </button>
              </div>
              <div className="flex gap-2 mt-3">
                {[30, 60, 90, 120, 300].map(sec => (
                  <button
                    key={sec}
                    onClick={() => setTargetTime(sec)}
                    className="flex-1 py-2 text-xs bg-orange-50 dark:bg-orange-900/30 text-orange-600 dark:text-orange-400 rounded-lg hover:bg-orange-100 dark:hover:bg-orange-900/50 transition-colors font-medium"
                  >
                    {sec < 60 ? `${sec}s` : `${sec/60}m`}
                  </button>
                ))}
              </div>
            </div>
          )}

          {!isRunning && time === 0 && mode === 'rest' && (
            <div className="mb-6">
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Rest Duration (seconds)
              </label>
              <div className="flex items-center gap-3">
                <button
                  onClick={() => setTargetTime(Math.max(10, targetTime - 10))}
                  className="p-3 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 rounded-xl transition-colors"
                >
                  <Minus className="w-5 h-5 text-gray-700 dark:text-gray-300" />
                </button>
                <input
                  type="number"
                  value={targetTime}
                  onChange={(e) => setTargetTime(Math.max(1, parseInt(e.target.value) || 1))}
                  className="flex-1 px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-center text-lg font-semibold text-gray-900 dark:text-white focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                />
                <button
                  onClick={() => setTargetTime(targetTime + 10)}
                  className="p-3 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 rounded-xl transition-colors"
                >
                  <Plus className="w-5 h-5 text-gray-700 dark:text-gray-300" />
                </button>
              </div>
              <div className="flex gap-2 mt-3">
                {[30, 60, 90, 120, 180].map(sec => (
                  <button
                    key={sec}
                    onClick={() => setTargetTime(sec)}
                    className="flex-1 py-2 text-xs bg-blue-50 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 rounded-lg hover:bg-blue-100 dark:hover:bg-blue-900/50 transition-colors font-medium"
                  >
                    {sec < 60 ? `${sec}s` : `${sec/60}m`}
                  </button>
                ))}
              </div>
            </div>
          )}

          {!isRunning && intervalTime === 0 && mode === 'interval' && (
            <div className="mb-6 space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Work Time (seconds)
                </label>
                <div className="flex items-center gap-3">
                  <button
                    onClick={() => setWorkTime(Math.max(5, workTime - 5))}
                    className="p-3 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 rounded-xl transition-colors"
                  >
                    <Minus className="w-4 h-4 text-gray-700 dark:text-gray-300" />
                  </button>
                  <input
                    type="number"
                    value={workTime}
                    onChange={(e) => setWorkTime(Math.max(5, parseInt(e.target.value) || 5))}
                    className="flex-1 px-3 py-2 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-center font-semibold text-gray-900 dark:text-white focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                  />
                  <button
                    onClick={() => setWorkTime(workTime + 5)}
                    className="p-3 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 rounded-xl transition-colors"
                  >
                    <Plus className="w-4 h-4 text-gray-700 dark:text-gray-300" />
                  </button>
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Rest Time (seconds)
                </label>
                <div className="flex items-center gap-3">
                  <button
                    onClick={() => setRestTime(Math.max(5, restTime - 5))}
                    className="p-3 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 rounded-xl transition-colors"
                  >
                    <Minus className="w-4 h-4 text-gray-700 dark:text-gray-300" />
                  </button>
                  <input
                    type="number"
                    value={restTime}
                    onChange={(e) => setRestTime(Math.max(5, parseInt(e.target.value) || 5))}
                    className="flex-1 px-3 py-2 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-center font-semibold text-gray-900 dark:text-white focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                  />
                  <button
                    onClick={() => setRestTime(restTime + 5)}
                    className="p-3 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 rounded-xl transition-colors"
                  >
                    <Plus className="w-4 h-4 text-gray-700 dark:text-gray-300" />
                  </button>
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Rounds
                </label>
                <div className="flex items-center gap-3">
                  <button
                    onClick={() => setRounds(Math.max(1, rounds - 1))}
                    className="p-3 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 rounded-xl transition-colors"
                  >
                    <Minus className="w-4 h-4 text-gray-700 dark:text-gray-300" />
                  </button>
                  <input
                    type="number"
                    value={rounds}
                    onChange={(e) => setRounds(Math.max(1, parseInt(e.target.value) || 1))}
                    className="flex-1 px-3 py-2 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-center font-semibold text-gray-900 dark:text-white focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                  />
                  <button
                    onClick={() => setRounds(rounds + 1)}
                    className="p-3 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 rounded-xl transition-colors"
                  >
                    <Plus className="w-4 h-4 text-gray-700 dark:text-gray-300" />
                  </button>
                </div>
              </div>

              <div className="flex gap-2">
                {[
                  { work: 20, rest: 10, rounds: 8, name: 'Tabata' },
                  { work: 30, rest: 15, rounds: 8, name: 'Classic' },
                  { work: 40, rest: 20, rounds: 6, name: 'Long' }
                ].map(preset => (
                  <button
                    key={preset.name}
                    onClick={() => {
                      setWorkTime(preset.work);
                      setRestTime(preset.rest);
                      setRounds(preset.rounds);
                      setIntervalTime(preset.work);
                    }}
                    className="flex-1 py-2 text-xs bg-purple-50 dark:bg-purple-900/30 text-purple-600 dark:text-purple-400 rounded-lg hover:bg-purple-100 dark:hover:bg-purple-900/50 transition-colors font-medium"
                  >
                    {preset.name}
                  </button>
                ))}
              </div>
            </div>
          )}

          {/* Action Buttons */}
          <div className="flex gap-3">
            <button
              onClick={handleStartPause}
              className={`flex-1 py-4 rounded-xl font-semibold text-white flex items-center justify-center gap-2 shadow-lg hover:shadow-xl transition-all ${
                isRunning 
                  ? 'bg-red-500 hover:bg-red-600 dark:bg-red-600 dark:hover:bg-red-700' 
                  : 'bg-gradient-to-r from-green-500 to-emerald-600 hover:from-green-600 hover:to-emerald-700 dark:from-green-600 dark:to-emerald-700'
              }`}
            >
              {isRunning ? (
                <>
                  <Pause className="w-6 h-6" />
                  Pause
                </>
              ) : (
                <>
                  <Play className="w-6 h-6" />
                  Start
                </>
              )}
            </button>
            <button
              onClick={handleReset}
              className="px-6 py-4 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 rounded-xl font-semibold text-gray-700 dark:text-gray-300 flex items-center gap-2 transition-colors shadow-md"
            >
              <RotateCcw className="w-5 h-5" />
              Reset
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
