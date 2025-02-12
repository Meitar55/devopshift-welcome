class MyHTTPError(Exception):
    """Exception raised for custom error scenarios.

    Attributes:
        message -- explanation of the error
    """
    def _init_(self, message):
        self.message = message
        super()._init_(self.message)