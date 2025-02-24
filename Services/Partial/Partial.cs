using System.Linq.Expressions;

namespace Services.Partial;

public class Partial<T>
{
    private readonly Dictionary<string, object> _updates = new();

    public void Set<TValue>(Expression<Func<T, TValue>> property, TValue value)
    {
        if (!IsDefaultValue(value))
        {
            var propertyName = ((MemberExpression)property.Body).Member.Name;
            _updates[propertyName] = value;
        }
    }

    public Dictionary<string, object> GetUpdates() => _updates;

    private bool IsDefaultValue<TValue>(TValue value)
    {
        return value switch
        {
            int i => i == 0,
            long l => l == 0L,
            float f => f == 0f,
            double d => d == 0.0,
            decimal m => m == 0m,
            DateTime dt => dt == default,
            _ => value == null
        };
    }
}
