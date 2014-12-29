
--uses Expressions class--

with Expressions;
use Expressions;

--defines what is in the class--

package Boolean_Expressions is

   --creates Relational Operators--

   type Relational_Operator is (EQ_OP, NE_OP, LT_OP, LE_OP, GT_OP, GE_OP);

   --declares variable Boolean_Expression private--

   type Boolean_Expression is private;

   --specifies function for creating a boolean expression that takes in--
   --relational operator, expression 1, and expression 2--
   --then returns the expression--

   function create_boolean_expression (op: in Relational_Operator;
                                       expr1, expr2: in Expression_Access)
                                       return Boolean_Expression;

   --specifies a function that evaluates the Boolean_Expression--
   --then returns boolean value--

   function evaluate (expr: in Boolean_Expression) return Boolean;

   --records the values for the relational operator--
   --expression 1, and expression 2 used in the evaluation--

private
   type Boolean_Expression is
      record
         op: Relational_Operator;
         expr1: Expression_Access;
         expr2: Expression_Access;
      end record;

   --ends this class--

end Boolean_Expressions;
