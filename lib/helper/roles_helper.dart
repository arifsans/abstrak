class RolesHelper {
  static const Map<String, String> roleNames = {
    '1': 'USER',
    '2': 'ARTIST',
    '3': 'ADMIN',
    '4': 'OWNER',
  };

  static String getRoleName(String roleId) {
    return roleNames[roleId] ?? 'USER';
  }
}