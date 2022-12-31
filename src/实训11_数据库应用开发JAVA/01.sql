/* 请在适当的位置补充代码，完成指定的任务 
   提示：
      try {


      } catch
    之间补充代码  
*/
import java.sql.*;

public class Client {
    static final String URL = "jdbc:postgresql://localhost:5432/postgres";
    static final String USER = "gaussdb";
    static final String PASS = "Passwd123@123";

    public static void main(String[] args) {
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("org.postgresql.Driver");
            connection = DriverManager.getConnection(URL,USER,PASS);
            statement = connection.createStatement();
            resultSet = statement.executeQuery("select c_name,c_mail,c_phone from client where c_mail is not null");
            System.out.print("姓名	邮箱				电话\n");
            while(resultSet.next()){
                System.out.print(resultSet.getString("c_name") + "\t");  
                System.out.print(resultSet.getString("c_mail") + "\t\t");  
                System.out.println(resultSet.getString("c_phone"));  
            }
 
         } catch (ClassNotFoundException e) {
            System.out.println("Sorry,can`t find the JDBC Driver!"); 
            e.printStackTrace();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (statement != null) {
                    statement.close();
                }

                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
    }
}
