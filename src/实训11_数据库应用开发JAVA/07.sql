import java.sql.*;

public class Transform {
  static final String JDBC_DRIVER = "org.postgresql.Driver";
    static final String DB_URL = "jdbc:postgresql://127.0.0.1:5432/postgres?";
    static final String USER = "gaussdb";
    static final String PASS = "Passwd123@123";
    
    /**
     * 向sc表中插入数据
     *
     */
    public static int insertSC(Connection con, int sno,
                                String col_name, int col_value){
      try {
        String sql = "insert into sc values (?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, sno);
        ps.setString(2, col_name);
        ps.setInt(3, col_value);
        return ps.executeUpdate();
      } 
      catch (Exception e) {
          e.printStackTrace();
      }
      return 0;
    }

    public static void main(String[] args) {
      try{
        Class.forName(JDBC_DRIVER);
        Connection con = DriverManager.getConnection(DB_URL,USER,PASS);
        String[] subjects = {"chinese", "math", "english", "physics", "chemistry", "biology", "history", "geography", "politics"};
        ResultSet res = con.createStatement().executeQuery("select * from entrance_exam");
        while(res.next()){
          int sno = res.getInt("sno");
          int score;
          for(String iter: subjects){
            score = res.getInt(iter);
            if(!res.wasNull())  //不要用 !=0 这种判定, 有逻辑漏洞
              insertSC(con, sno, iter, score);
          }
        }
      }
      catch(Exception e){
        e.printStackTrace();
      }

    }
}