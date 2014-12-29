package body Boolean_Expressions is


   -- create_boolean_expression with parameters of each type--
   --relational operator, expression 1, and expression 2--


   function create_boolean_expression (op: in Relational_Operator;
                                       expr1, expr2: in Expression_Access)


      --returns Boolean expression that was created--


                                       return Boolean_Expression is
      expr: Boolean_Expression;

      --assigns the parameters the new values--

   begin
      expr.op := op;
      expr.expr1 := expr1;
      expr.expr2 := expr2;
      return expr;
   end create_boolean_expression;


   -- evaluate boolean expresions--
   --returns boolean--


   function evaluate (expr: in Boolean_Expression) return Boolean is

      result: Boolean;

      --gives a case and returns the result--

   begin
      case expr.op is
         when EQ_OP =>
            result := evaluate (expr.expr1) = evaluate (expr.expr2);
         when NE_OP =>
            result := evaluate (expr.expr1) /= evaluate (expr.expr2);
         when LE_OP =>
            result := evaluate (expr.expr1) <= evaluate (expr.expr2);
         when LT_OP =>
            result := evaluate (expr.expr1) < evaluate (expr.expr2);
         when GE_OP =>
            result := evaluate (expr.expr1) >= evaluate (expr.expr2);
         when GT_OP =>
            result := evaluate (expr.expr1) > evaluate (expr.expr2);
      end case;
      return result;

      --ends the evaulate function--

   end evaluate;

   --ends the boolean expression class--

end Boolean_Expressions;
