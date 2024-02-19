// generic exceptions
class AuthExceptionGeneric implements Exception {}

class AuthExceptionEmptyFields implements Exception {}

// register exceptions
class AuthExceptionInvalidEmail implements Exception {}

class AuthExceptionEmailAlreadyInUse implements Exception {}

class AuthExceptionWeakPassword implements Exception {}

class AuthExceptionPasswordsDontMatch implements Exception {}

// log in exceptions
class AuthExceptionInvalidCredentials implements Exception {}

class AuthExceptionUserNotLoggedIn implements Exception {}
