class BloodDetail {
  final String Id;
  final String recipientName;
  final String contactNo;
  final String address;
  final String blood_group;
  String status;
  final String recipientFormId;
  final String recipientId;

  BloodDetail({
    required this.Id,
    required this.recipientId,
    required this.recipientFormId,
    required this.recipientName,
    required this.contactNo,
    required this.address,
    required this.blood_group,
    required this.status,
  });
}