internal class AccessToken
{
    public var error: String?
    public var accessToken: String?
    
    public init(accessToken: String?, error: String?)
    {
        self.error = error
        self.accessToken = accessToken
    }
}
