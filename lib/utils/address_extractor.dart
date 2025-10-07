class AddressExtractor {
  static (String, String) extractAddress({
    required List<String> street1,
    required List<String> street2,
    required List<String> area,
    required List<String> city,
    required List<String> state,
    required List<String> country,
    required List<String> pincode,
  }) {
    String oldAddress = "";
    String newAddress = "";
    if (street1.isNotEmpty) {
      oldAddress += street1[0];
      if (street1.length > 1) {
        newAddress += street1[1];
      }
    }
    if (street2.isNotEmpty) {
      if (oldAddress.isNotEmpty) oldAddress += ", ";
      oldAddress += street2[0];
      if (street2.length > 1) {
        if (newAddress.isNotEmpty) newAddress += ", ";
        newAddress += street2[1];
      }
    }
    if (area.isNotEmpty) {
      if (oldAddress.isNotEmpty) oldAddress += ", ";
      oldAddress += area[0];
      if (area.length > 1) {
        if (newAddress.isNotEmpty) newAddress += ", ";
        newAddress += area[1];
      }
    }
    if (city.isNotEmpty) {
      if (oldAddress.isNotEmpty) oldAddress += ", ";
      oldAddress += city[0];
      if (city.length > 1) {
        if (newAddress.isNotEmpty) newAddress += ", ";
        newAddress += city[1];
      }
    }
    if (state.isNotEmpty) {
      if (oldAddress.isNotEmpty) oldAddress += ", ";
      oldAddress += state[0];
      if (state.length > 1) {
        if (newAddress.isNotEmpty) newAddress += ", ";
        newAddress += state[1];
      }
    }
    if (country.isNotEmpty) {
      if (oldAddress.isNotEmpty) oldAddress += ", ";
      oldAddress += country[0];
      if (country.length > 1) {
        if (newAddress.isNotEmpty) newAddress += ", ";
        newAddress += country[1];
      }
    }
    if (pincode.isNotEmpty) {
      if (oldAddress.isNotEmpty) oldAddress += ", ";
      oldAddress += pincode[0];
      if (pincode.length > 1) {
        if (newAddress.isNotEmpty) newAddress += ", ";
        newAddress += pincode[1];
      }
    }
    return (oldAddress, newAddress);
  }
}
