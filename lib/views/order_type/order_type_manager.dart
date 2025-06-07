class OrderTypeManager {
  // Default value is 'Dine In'
  static String selectedType = 'Dine In';

  /// Sets the order type
  static void setOrderType(String type) {
    selectedType = type;
  }

  /// Gets the current order type
  static String getOrderType() {
    return selectedType;
  }
}