import { useState } from 'react';
import { X, Plus, TrendingUp, TrendingDown, Ruler } from 'lucide-react';

interface Measurement {
  date: string;
  weight: number;
  chest?: number;
  waist?: number;
  hips?: number;
  arms?: number;
  thighs?: number;
}

interface MeasurementsTrackerProps {
  isOpen: boolean;
  onClose: () => void;
  measurements: Measurement[];
  onAddMeasurement: (measurement: Omit<Measurement, 'date'>) => void;
}

export function MeasurementsTracker({ isOpen, onClose, measurements, onAddMeasurement }: MeasurementsTrackerProps) {
  const [weight, setWeight] = useState('');
  const [chest, setChest] = useState('');
  const [waist, setWaist] = useState('');
  const [hips, setHips] = useState('');
  const [arms, setArms] = useState('');
  const [thighs, setThighs] = useState('');

  if (!isOpen) return null;

  const handleSubmit = () => {
    if (weight) {
      onAddMeasurement({
        weight: parseFloat(weight),
        chest: chest ? parseFloat(chest) : undefined,
        waist: waist ? parseFloat(waist) : undefined,
        hips: hips ? parseFloat(hips) : undefined,
        arms: arms ? parseFloat(arms) : undefined,
        thighs: thighs ? parseFloat(thighs) : undefined,
      });
      setWeight('');
      setChest('');
      setWaist('');
      setHips('');
      setArms('');
      setThighs('');
    }
  };

  const latestMeasurement = measurements[0];
  const previousMeasurement = measurements[1];

  const getChange = (current?: number, previous?: number) => {
    if (!current || !previous) return null;
    const change = current - previous;
    return {
      value: Math.abs(change).toFixed(1),
      isIncrease: change > 0
    };
  };

  return (
    <div className="fixed inset-0 bg-black/60 z-50 flex items-center justify-center p-4 backdrop-blur-sm overflow-y-auto">
      <div className="bg-white dark:bg-gray-800 rounded-3xl max-w-2xl w-full my-8 shadow-2xl border border-gray-200 dark:border-gray-700">
        {/* Header */}
        <div className="bg-gradient-to-r from-teal-500 to-cyan-600 dark:from-teal-600 dark:to-cyan-700 p-6 text-white rounded-t-3xl">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-white/20 rounded-xl">
                <Ruler className="w-6 h-6" />
              </div>
              <div>
                <h2 className="text-2xl font-bold">Body Measurements</h2>
                <p className="text-sm text-white/90">Track your progress over time</p>
              </div>
            </div>
            <button 
              onClick={onClose}
              className="p-2 hover:bg-white/20 rounded-full transition-colors"
            >
              <X className="w-6 h-6" />
            </button>
          </div>
        </div>

        <div className="p-6 space-y-6">
          {/* Current Measurements */}
          {latestMeasurement && (
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-4">
                Latest Measurements
              </h3>
              <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
                {[
                  { label: 'Weight', value: latestMeasurement.weight, unit: 'kg', key: 'weight' },
                  { label: 'Chest', value: latestMeasurement.chest, unit: 'cm', key: 'chest' },
                  { label: 'Waist', value: latestMeasurement.waist, unit: 'cm', key: 'waist' },
                  { label: 'Hips', value: latestMeasurement.hips, unit: 'cm', key: 'hips' },
                  { label: 'Arms', value: latestMeasurement.arms, unit: 'cm', key: 'arms' },
                  { label: 'Thighs', value: latestMeasurement.thighs, unit: 'cm', key: 'thighs' },
                ].map(({ label, value, unit, key }) => {
                  if (!value) return null;
                  const change = getChange(value, previousMeasurement?.[key as keyof Measurement] as number);
                  return (
                    <div
                      key={label}
                      className="bg-gradient-to-br from-gray-50 to-gray-100 dark:from-gray-900/50 dark:to-gray-800 p-4 rounded-xl border border-gray-200 dark:border-gray-700"
                    >
                      <div className="text-xs text-gray-500 dark:text-gray-400 mb-1">{label}</div>
                      <div className="text-2xl font-bold text-gray-900 dark:text-white mb-1">
                        {value}{unit}
                      </div>
                      {change && (
                        <div className={`text-xs flex items-center gap-1 ${
                          change.isIncrease
                            ? 'text-red-600 dark:text-red-400'
                            : 'text-green-600 dark:text-green-400'
                        }`}>
                          {change.isIncrease ? (
                            <TrendingUp className="w-3 h-3" />
                          ) : (
                            <TrendingDown className="w-3 h-3" />
                          )}
                          {change.value}{unit}
                        </div>
                      )}
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* Add New Measurement */}
          <div className="border-t border-gray-200 dark:border-gray-700 pt-6">
            <h3 className="font-semibold text-gray-900 dark:text-white mb-4">
              Add New Measurement
            </h3>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Weight (kg) *
                </label>
                <input
                  type="number"
                  step="0.1"
                  value={weight}
                  onChange={(e) => setWeight(e.target.value)}
                  placeholder="70.5"
                  className="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-teal-500 focus:border-transparent"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Chest (cm)
                </label>
                <input
                  type="number"
                  step="0.1"
                  value={chest}
                  onChange={(e) => setChest(e.target.value)}
                  placeholder="95"
                  className="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-teal-500 focus:border-transparent"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Waist (cm)
                </label>
                <input
                  type="number"
                  step="0.1"
                  value={waist}
                  onChange={(e) => setWaist(e.target.value)}
                  placeholder="80"
                  className="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-teal-500 focus:border-transparent"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Hips (cm)
                </label>
                <input
                  type="number"
                  step="0.1"
                  value={hips}
                  onChange={(e) => setHips(e.target.value)}
                  placeholder="95"
                  className="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-teal-500 focus:border-transparent"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Arms (cm)
                </label>
                <input
                  type="number"
                  step="0.1"
                  value={arms}
                  onChange={(e) => setArms(e.target.value)}
                  placeholder="35"
                  className="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-teal-500 focus:border-transparent"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Thighs (cm)
                </label>
                <input
                  type="number"
                  step="0.1"
                  value={thighs}
                  onChange={(e) => setThighs(e.target.value)}
                  placeholder="55"
                  className="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-teal-500 focus:border-transparent"
                />
              </div>
            </div>
            <button
              onClick={handleSubmit}
              disabled={!weight}
              className="w-full mt-4 py-4 bg-gradient-to-r from-teal-500 to-cyan-600 hover:from-teal-600 hover:to-cyan-700 disabled:from-gray-400 disabled:to-gray-500 disabled:cursor-not-allowed text-white rounded-xl font-semibold shadow-lg hover:shadow-xl transition-all flex items-center justify-center gap-2"
            >
              <Plus className="w-5 h-5" />
              Add Measurement
            </button>
          </div>

          {/* History */}
          {measurements.length > 0 && (
            <div className="border-t border-gray-200 dark:border-gray-700 pt-6">
              <h3 className="font-semibold text-gray-900 dark:text-white mb-4">
                Measurement History
              </h3>
              <div className="space-y-3 max-h-60 overflow-y-auto">
                {measurements.map((measurement, index) => (
                  <div
                    key={index}
                    className="bg-gray-50 dark:bg-gray-900/50 p-4 rounded-xl border border-gray-200 dark:border-gray-700"
                  >
                    <div className="flex justify-between items-start mb-2">
                      <div className="text-sm font-medium text-gray-900 dark:text-white">
                        {new Date(measurement.date).toLocaleDateString('en-IN', { 
                          day: 'numeric', 
                          month: 'short', 
                          year: 'numeric' 
                        })}
                      </div>
                      <div className="text-lg font-bold text-teal-600 dark:text-teal-400">
                        {measurement.weight}kg
                      </div>
                    </div>
                    <div className="grid grid-cols-5 gap-2 text-xs">
                      {measurement.chest && (
                        <div className="text-center">
                          <div className="text-gray-500 dark:text-gray-400">Chest</div>
                          <div className="font-medium text-gray-900 dark:text-white">{measurement.chest}</div>
                        </div>
                      )}
                      {measurement.waist && (
                        <div className="text-center">
                          <div className="text-gray-500 dark:text-gray-400">Waist</div>
                          <div className="font-medium text-gray-900 dark:text-white">{measurement.waist}</div>
                        </div>
                      )}
                      {measurement.hips && (
                        <div className="text-center">
                          <div className="text-gray-500 dark:text-gray-400">Hips</div>
                          <div className="font-medium text-gray-900 dark:text-white">{measurement.hips}</div>
                        </div>
                      )}
                      {measurement.arms && (
                        <div className="text-center">
                          <div className="text-gray-500 dark:text-gray-400">Arms</div>
                          <div className="font-medium text-gray-900 dark:text-white">{measurement.arms}</div>
                        </div>
                      )}
                      {measurement.thighs && (
                        <div className="text-center">
                          <div className="text-gray-500 dark:text-gray-400">Thighs</div>
                          <div className="font-medium text-gray-900 dark:text-white">{measurement.thighs}</div>
                        </div>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
