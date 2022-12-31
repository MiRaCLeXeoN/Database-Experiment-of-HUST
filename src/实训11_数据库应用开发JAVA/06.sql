import java.sql.*;
import java.util.Scanner;

public class Transfer {
    static final String JDBC_DRIVER = "org.postgresql.Driver";
    static final String DB_URL = "jdbc:postgresql://127.0.0.1:5432/postgres?";
    static final String USER = "gaussdb";
    static final String PASS = "Passwd123@123";
    /**
     * 转账操作
     *
     * @param connection 数据库连接对象
     * @param sourceCard 转出账号
     * @param destCard 转入账号
     * @param amount  转账金额
     * @return boolean
     *   true  - 转账成功
     *   false - 转账失败
     */
    public static boolean transferBalance(Connection connection,
                             String sourceCard,
                             String destCard, 
                             double amount){
        try {
            connection.setAutoCommit(false);

            String sql = "select * from bank_card where b_number = ?";
            //检查转出卡是否符合要求
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, sourceCard);
            ResultSet res = ps.executeQuery();
            if (!res.next())
                return false;
            if(res.getString("b_type").replaceAll(" ","").equals("信用卡") || res.getDouble("b_balance") < amount)
                return false;
            ps.close();

            //检查转入卡是否存在
            ps = connection.prepareStatement(sql);
            ps.setString(1, destCard);
            res = ps.executeQuery();
            if (!res.next())
                return false;
            
            sql = "update bank_card set b_balance = b_balance + ? where b_number = ?";
            ps = connection.prepareStatement(sql);
            ps.setDouble(1, -amount);
            ps.setString(2, sourceCard);
            ps.executeUpdate();

            ps = connection.prepareStatement(sql);
            ps.setDouble(1, res.getString("b_type").replaceAll(" ","").equals("信用卡") ? -amount : amount);
            ps.setString(2, destCard);
            ps.executeUpdate();

            connection.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;

    }

    // 不要修改main() 
    public static void main(String[] args) throws Exception {

        Scanner sc = new Scanner(System.in);
        Class.forName(JDBC_DRIVER);

        Connection connection = DriverManager.getConnection(DB_URL, USER, PASS);

        while(sc.hasNext())
        {
            String input = sc.nextLine();
            if(input.equals(""))
                break;

            String[]commands = input.split(" ");
            if(commands.length ==0)
                break;
            String payerCard = commands[0];
            String  payeeCard = commands[1];
            double  amount = Double.parseDouble(commands[2]);
            if (transferBalance(connection, payerCard, payeeCard, amount)) {
              System.out.println("转账成功。" );
            } else {
              System.out.println("转账失败,请核对卡号，卡类型及卡余额!");
            }
        }
    }

}
