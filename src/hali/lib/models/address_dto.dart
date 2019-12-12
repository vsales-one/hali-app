
class AddressDto {
  final String streetAddress;
  final String ward;
  final String district;
  final String city;
  final String country;

  AddressDto({this.streetAddress, this.ward, this.district, this.city, this.country});

  factory AddressDto.fromFullAddress(String fullAddress) {
    assert(fullAddress != null && fullAddress.isNotEmpty);
    final parts = fullAddress.trim().split(",");
    String streetAddress;
    String ward;
    String district;
    String city;
    String country;
    
    if(parts.length >= 1)
      streetAddress = parts[0];
    if(parts.length >= 2)
      ward = parts[1];
    if(parts.length >= 3)
      district = parts[2];
    if(parts.length >= 4)
      city = parts[3];
    if(parts.length >= 5)
      country = parts[4];
    return AddressDto(
      streetAddress: streetAddress,
      ward: ward,
      district: district,
      city: city,
      country: country
    );
  }

  @override
  String toString() {
    return "$streetAddress, $ward, $district, $city, $country";
  }

  String toShortAddress() {
    return "$streetAddress, $ward, $district";
  }
}