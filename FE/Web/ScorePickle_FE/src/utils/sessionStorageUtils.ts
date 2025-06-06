/**
 * Set a value in session storage
 * @param key - The key to set the value under
 * @param value - The value to set
 */
export function setSessionStorage(key: string, value: unknown) {
  sessionStorage.setItem(key, JSON.stringify(value));
}

/**
 * Get a value from session storage
 * @param key - The key to get the value for
 * @returns The value stored under the key, or null if not found
 */
export function getSessionStorage(key: string): unknown {
  const value = sessionStorage.getItem(key);
  return value ? JSON.parse(value) : null;
}

/**
 * Remove a value from session storage
 * @param key - The key to remove the value for
 */
export function removeSessionStorage(key: string) {
  sessionStorage.removeItem(key);
}

/**
 * Clear all values from session storage
 */
export function clearSessionStorage() {
  sessionStorage.clear();
}

export function sessionItemExists(key: string): boolean {
  try {
    return sessionStorage.getItem(key) !== null;
  } catch (error) {
    console.error('Error checking sessionStorage item:', error);
    return false;
  }
}
