export function setLocalStorageItem(key: string, value: unknown): void {
  try {
    const serializedValue = JSON.stringify(value);
    localStorage.setItem(key, serializedValue);
  } catch (error) {
    console.error('Error setting item in Local Storage:', error);
  }
}

export function getLocalStorageItem(key: string): unknown | null {
  try {
    const serializedValue = localStorage.getItem(key) ?? null;
    if (!serializedValue) return null;
    return JSON.parse(serializedValue);
  } catch (error) {
    console.error('Error getting item from Local Storage:', error);
    return null;
  }
}

export function removeLocalStorageItem(key: string): void {
  try {
    localStorage.removeItem(key);
  } catch (error) {
    console.error('Error removing item from Local Storage:', error);
  }
}

export function localItemExists(key: string): boolean {
  try {
    return localStorage.getItem(key) !== null;
  } catch (error) {
    console.error('Error checking localStorage item:', error);
    return false;
  }
}
