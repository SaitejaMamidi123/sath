global class FutureUtilityClass {
    
    @future
    public static void changeUserRoleAsync(Id userId,String roleName)
    {
       Id userRoleId = [Select Id From UserRole Where developername =: roleName limit 1 ].Id;

		User userRecord = new User();

		userRecord.Id = userId;

		userRecord.UserRoleId = userRoleId;

		Update userRecord; 
        
    }
    
    @future
    public static void changeuserxx(Id userId,String roleName)
    {
        Id userRoleId=[select id from userrole where developername =: rolename].Id;
    User newUser=new User();
    newUser.Id = userId;
    newUser.userRoleId=userRoleId;
    Update newUser;
    }
    

}