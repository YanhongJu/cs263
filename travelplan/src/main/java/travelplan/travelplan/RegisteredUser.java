package travelplan.travelplan;
import com.google.gson.annotations.SerializedName;

public class RegisteredUser {
	@SerializedName("userID")
	private int id;
	private String userEmail;
	private String password;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
	public String toString(){
        StringBuilder sb = new StringBuilder();        
        sb.append("ID="+getId()+"\n");
        sb.append("userEmail="+getUserEmail()+"\n");
        sb.append("password="+getPassword()+"\n");          
        return sb.toString();
    }

}
