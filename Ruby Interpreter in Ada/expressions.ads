--uses the class of literal integers and ids--

with Literal_Integers, Ids;
use  Literal_Integers, Ids;

--starts class--

package Expressions is

   --defines Arithmetic Operator-

   type Arithmetic_Operator is (ADD_OP, SUB_OP, MUL_OP, DIV_OP);

   --defines Expression_Type--


   type Expression_Type is (BINARY_EXPR, CONST_EXPR, VAR_EXPR);

   --defines Expression--

   type Expression (expr_type : Expression_Type) is private;

   --Expression is private--

   type Expression_Access is access Expression;

   --Expression_Access points to Expression (I think)--

   function create_binary_expression (op: in Arithmetic_Operator;
                                      expr1, expr2: in Expression_Access)
                                      return Expression_Access

   --not sure what is this does, maybe makes the null exception--

   with pre => expr1 /= null and expr2 /= null;

   --creates variable expression--

   function create_var_expression (var: in Id) return Expression_Access;

   --creates constant expression--

   function create_const_expression (li: in Literal_Integer) return Expression_Access;

   --function that evaluates an expression and returns the integer--
   --again, not sure what the pre => expr /= null;

   function evaluate (expr: in Expression_Access) return Integer
   with pre => expr /= null;

   --records the values for each case--

private
   type Expression (expr_type : Expression_Type) is record
      case expr_type is
         when CONST_EXPR =>
            li : Literal_Integer;
         when VAR_EXPR =>
            var : Id;
         when BINARY_EXPR =>
            op    : Arithmetic_Operator;
            expr1 : Expression_Access;
            expr2 : Expression_Access;
      end case;
   end record;

end Expressions;
