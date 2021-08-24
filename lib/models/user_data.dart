class UserData {
  final String uid;
  final String email;
  final String namaLengkap;
  final String tglLahir;
  final String gender;
  final String role;
  final String imageUrl;
  final String tempatPraktek;

  UserData(
      {this.email = '',
      this.uid = '',
      this.namaLengkap = '',
      this.tglLahir = '',
      this.gender = '',
      this.role = '',
      this.imageUrl,
      this.tempatPraktek});
}
