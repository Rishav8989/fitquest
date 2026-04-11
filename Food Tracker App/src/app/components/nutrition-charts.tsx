import { PieChart, Pie, Cell, ResponsiveContainer, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, LineChart, Line } from 'recharts';

interface NutritionChartsProps {
  dailyData: {
    calories: number;
    protein: number;
    carbs: number;
    fat: number;
    fiber: number;
  };
  weeklyData: Array<{
    day: string;
    calories: number;
    protein: number;
  }>;
  goals: {
    calories: number;
    protein: number;
    carbs: number;
    fat: number;
  };
}

export function NutritionCharts({ dailyData, weeklyData, goals }: NutritionChartsProps) {
  const macroData = [
    { name: 'Protein', value: dailyData.protein, color: '#10b981' },
    { name: 'Carbs', value: dailyData.carbs, color: '#3b82f6' },
    { name: 'Fat', value: dailyData.fat, color: '#f59e0b' },
  ];

  const goalsData = [
    {
      name: 'Calories',
      current: dailyData.calories,
      goal: goals.calories,
      color: '#8b5cf6'
    },
    {
      name: 'Protein',
      current: dailyData.protein,
      goal: goals.protein,
      color: '#10b981'
    },
    {
      name: 'Carbs',
      current: dailyData.carbs,
      goal: goals.carbs,
      color: '#3b82f6'
    },
    {
      name: 'Fat',
      current: dailyData.fat,
      goal: goals.fat,
      color: '#f59e0b'
    },
  ];

  return (
    <div className="space-y-6">
      <div className="bg-white border border-gray-200 rounded-xl p-6">
        <h3 className="font-semibold text-gray-900 mb-4">Macronutrient Distribution</h3>
        <div className="flex items-center gap-8">
          <div className="w-48 h-48">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie
                  data={macroData}
                  cx="50%"
                  cy="50%"
                  innerRadius={50}
                  outerRadius={80}
                  paddingAngle={5}
                  dataKey="value"
                >
                  {macroData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={entry.color} />
                  ))}
                </Pie>
              </PieChart>
            </ResponsiveContainer>
          </div>
          <div className="flex-1 space-y-3">
            {macroData.map((macro) => (
              <div key={macro.name} className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div
                    className="w-3 h-3 rounded-full"
                    style={{ backgroundColor: macro.color }}
                  />
                  <span className="text-sm text-gray-700">{macro.name}</span>
                </div>
                <span className="font-semibold text-gray-900">{macro.value.toFixed(1)}g</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      <div className="bg-white border border-gray-200 rounded-xl p-6">
        <h3 className="font-semibold text-gray-900 mb-4">Daily Goals Progress</h3>
        <div className="h-64">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={goalsData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
              <XAxis dataKey="name" stroke="#6b7280" fontSize={12} />
              <YAxis stroke="#6b7280" fontSize={12} />
              <Tooltip
                contentStyle={{
                  backgroundColor: '#fff',
                  border: '1px solid #e5e7eb',
                  borderRadius: '8px',
                }}
              />
              <Legend />
              <Bar dataKey="current" fill="#10b981" name="Current" radius={[8, 8, 0, 0]} />
              <Bar dataKey="goal" fill="#d1d5db" name="Goal" radius={[8, 8, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>

      <div className="bg-white border border-gray-200 rounded-xl p-6">
        <h3 className="font-semibold text-gray-900 mb-4">Weekly Trends</h3>
        <div className="h-64">
          <ResponsiveContainer width="100%" height="100%">
            <LineChart data={weeklyData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
              <XAxis dataKey="day" stroke="#6b7280" fontSize={12} />
              <YAxis stroke="#6b7280" fontSize={12} />
              <Tooltip
                contentStyle={{
                  backgroundColor: '#fff',
                  border: '1px solid #e5e7eb',
                  borderRadius: '8px',
                }}
              />
              <Legend />
              <Line
                type="monotone"
                dataKey="calories"
                stroke="#8b5cf6"
                strokeWidth={2}
                dot={{ fill: '#8b5cf6', r: 4 }}
                name="Calories"
              />
              <Line
                type="monotone"
                dataKey="protein"
                stroke="#10b981"
                strokeWidth={2}
                dot={{ fill: '#10b981', r: 4 }}
                name="Protein (g)"
              />
            </LineChart>
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  );
}
