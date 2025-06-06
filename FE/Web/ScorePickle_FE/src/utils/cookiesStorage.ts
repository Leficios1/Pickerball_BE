class CookieStorage {
  // Đọc giá trị của cookie theo tên
  static get(name: string): string | null {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) return parts.pop()?.split(';').shift() ?? null;
    return null;
  }

  // Ghi một cookie mới hoặc cập nhật cookie hiện tại
  static set(name: string, value: string, days: number = 7): void {
    const expires = new Date();
    expires.setTime(expires.getTime() + days * 24 * 60 * 60 * 1000); // Thiết lập ngày hết hạn
    document.cookie = `${name}=${value}; expires=${expires.toUTCString()}; path=/`;
  }

  // Xóa cookie theo tên
  static delete(name: string): void {
    document.cookie = `${name}=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/`;
  }

  // Kiểm tra sự tồn tại của cookie
  static exists(name: string): boolean {
    return this.get(name) !== null;
  }
}

export default CookieStorage;
