with Lexical_Analyzers, Programs, Tokens, Statements, Ids, Literal_Integers, Expressions, Boolean_Expressions;
use  Lexical_Analyzers, Programs, Tokens, Statements, Ids, Literal_Integers, Expressions, Boolean_Expressions;

package body Parsers is

   --declaration of functions--

     procedure get_code_block(p: in out Parser; cb: out Code_Block);

   function get_statement (tokenType: in Token_Type; p: in out Parser) return Statement_Access;

   function get_while_statement (p: in out Parser) return Statement_Access;

   function get_until_statement (p: in out Parser) return Statement_Access;

   function get_if_statement (p: in out Parser) return Statement_Access;

   function get_print_statement (p: in out Parser) return Statement_Access;

   function get_assignment (p: in out Parser) return Statement_Access;

   function get_expression (p: out Parser) return Expression_Access;

   function get_arithmetic_operator (tok: in Token) return Arithmetic_Operator;

   function get_boolean_expression (tok: in Token) return Boolean_Expression;

   function get_relational_operator (tok: in Token) return Relational_Operator;

--create our parser--

   function create_parser(file_name: in String) return Parser is

      parser: Parser;

   begin

      --create the lexical analyzer of the parser--

      parser.lex := create_lexical_analyzer(file_name);

      return parser;
   end create_parser;

   --parse procedure--

   procedure parse (p: in out Parser; prog: out Program) is

   tok: Token;
   cb: Code_Block;

   --codeblocks are delimited by begin and end in ada--

   begin

   get_next_token(p.lex, tok);

   --if token type is not DEF, then there is an error (equivalent to Java match method)--
   if get_token_type (tok) /= DEF_TOK then
      raise parser_exception with "Invalid token type at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
   end if;
   --next we get our codeblock--
   get_codeblock(p, cb);
   prog := create_program(cb);
   get_next_token(p.lex, tok);
   --if token type is not END, then there is an error (equivalent to Java match method)--
   if get_token_type (tok) /= END_TOK then
      raise parser_exception with "Invalid token type at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
   end if;
   get_next_token(p.lex, tok);
   --if token type is not EOS, then there is garbage at the end of the program (equivalent to Java match method)--
   if get_token_type (tok) /= EOS_TOK then
      raise parser_exception with "garbage at the end of program at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
   end if;
end parse;

--function to get code block--

procedure get_code_block(p: in out Parser; cb: out Code_Block) is

   previewNextToken: Token;
   stmt: Statement_Access;

begin

--gets first statements for the codeblock--

   previewNextToken:= get_lookahead_token(p.lex);
   stmt:= get_statement(get_token_type(previewNextToken), p);
   --adds statement to the codeblock--
   add(cb, stmt);
   --previews the next token--
   previewNextToken:= get_lookahead_token(p.lex);

      --if the next token is null then we have an error--

   if previewNextToken = NULL then
      raise parser_exception with "There is a null token at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
   end if;

   --mixing the get code block with the isValidStatement method from Java--

   while
        get_token_type(previewNextToken) = ID_TOK or get_token_type(previewNextToken) = PUTS_TOK or
        get_token_type(previewNextToken) = IF_TOK or get_token_type(previewNextToken) = WHILE_TOK
     get_token_type(previewNextToken) = UNTIL_TOK loop

         stmt:= get_statement(get_token_type(previewNextToken), p);
         --adds the statement to the codeblock--
      add(cb, stmt);
      previewNextToken:= get_lookahead_token(p.lex);

   end loop;

end get_codeblock;

   --function to get a statement--

function get_statement (tokenType: in Token_Type; p: in out Parser) return Statement_Access is

   stmt: Statement_Access;
   previewNextToken: Token;

begin
      case tokenType is

         --when there is an ID TOK, get assignment--
      when ID_TOK =>
         stmt:= get_assignment(p);
         --PUTS = print--
         when PUTS_TOK =>
            stmt:= get_print_statement(p);
            --if = if statement--
         when IF_TOK =>
            stmt:= get_if_statement(p);
            --while, etc.--
         when WHILE_TOK =>
            stmt:= get_while_statement(p);
            --until, etc.--
         when UNTIL_TOK =>
            stmt:= get_until_statement(p);
            --when the token type is anything other than these, we have the following--
      when others =>
         previewNextToken:= get_lookahead_token(p.lex);
         raise parser_exception with "statement expected at row " &
        Positive'Image(get_row_number(previewNextToken)) & " and column " &
           Positive'Image(get_column_number(previewNextToken));
   end case;

   return stmt;

   end get_statement;

   --get print stmt--

    function get_print_statement (p: in out Parser) return Statement_Access is

   tok: Token;
   expr: Expression_Access;

   begin

   get_next_token(p.lex, tok);
   if get_token_type (tok) /= PUTS_TOK then
      raise parser_exception with "PUTS token should be at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
   end if;
   expr:= get_expression(p);

   return create_print_statement(expr);

   end get_print_statement;

   --get while statement--
   --while <boolean expression> do <codeblock> end--

   function get_while_statement (p: in out Parser) return Statement_Access is

   tok: Token;
   booleanExpression: Boolean_Expression;
   cb1: Code_Block;

   begin

      --we expect to begin with while, therefore--

   previewNextToken:= get_lookahead_token(p.lex);
   if get_token_type (tok) /= WHILE_TOK then
      raise parser_exception with "WHILE token should be at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
      end if;
-- next should follow the boolean expression--
      booleanExpression := get_boolean_expression(p);
   get_next_token(p);
      previewNextToken:= get_lookahead_token(p.lex);
      --we should get a DO TOK but if not--
   if get_token_type (tok) /= DO_TOK then
      raise parser_exception with "DO token should be at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
      end if;

      --now we get our codeblock--
   get_code_block(p, cb1);
      get_next_token(p.lex, tok);

      --the last token should be end--
   if get_token_type (tok) /= END_TOK then
      raise parser_exception with "END token should be at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
   end if;

   return create_while_statement(booleanExpression, cb1);

   end get_while_statement;

   --until <boolean expression> do <code block> end--

   function get_until_statement (p: in out Parser) return Statement_Access is

   tok: Token;
   booleanExpression: Boolean_Expression;
   cb1: Code_Block;

   begin
-- we expect an until tok--
   get_next_token(p.lex, tok);
   if get_token_type (tok) /= UNTIL_TOK then
      raise parser_exception with "UNTIL token should be at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
      end if;

      --we get our boolean expression--
   booleanExpression:= get_boolean_expression(p);
      get_next_token(p.lex, tok);

      --the next token should be do--
   if get_token_type (tok) /= DO_TOK then
      raise parser_exception with "DO token should be at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
      end if;

      --we retrieve our codeblock--
   get_code_block(p, cb1);
      get_next_token(p.lex, tok);

      --finally we should look ahead to determine if the token is END--
   if get_token_type (tok) /= END_TOK then
      raise parser_exception with "END token should be at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
   end if;

   return create_until_statement(expr, cb);

   end get_until_statement;

   --get assignment--

   function get_assignment (p: in out Parser) return Statement_Access is

   tok: Token;
   var: Id;
   expr: Expression_Access;

begin
   get_next_token (p.lex, tok);
   if get_token_type(tok) /= ID_TOK then
      raise parser_exception with "ID token expected at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
      end if;

   get_next_token (p.lex, tok);
   if get_token_type(tok) /= ASSIGN_OP then
      raise parser_exception with "Assignment operator expected at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
   end if;

   expr:= get_expression(p);

   return create_assignment(var, expr);

   end get_assignment;

   --if <boolean expression> then <codeblock> else <codeblock> end--

   function get_if_statement (p: in out Parser) return Statement_Access is

   tok: Token;
   booleanExpression: Boolean_Expression;
   cb1: Code_Block;
   cb2: Code_Block;

   begin
--we look to see if the next token will be if tok--
   get_next_token(p.lex, tok);
   if get_token_type (tok) /= IF_TOK then
      raise parser_exception with "IF token should be at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
      end if;

      --we get our boolean expression--
   booleanExpression:= get_boolean_expression(p);
      get_next_token(p.lex);

      --we see if the next token is THEN TOK--
   if get_token_type (tok) /= THEN_TOK then
      raise parser_exception with "DO token should be at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
      end if;

      -- we get our code block--
   get_code_block(p, cb1);
      get_next_token(p.lex);

      --else tok--
   if get_token_type (tok) /= ELSE_TOK then
      raise parser_exception with "ELSE token should be at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
      end if;

      --retrieve our next code block--
   get_code_block(p, cb2);
      get_next_token(p.lex);

      --end tok--
   if get_token_type (tok) /= END_TOK then
      raise parser_exception with "END token should be at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
   end if;

   return create_if_statement(booleanExpression, cb1, cb2);

   end get_if_statement;


   function get_boolean_expression(p: out Parser) return Boolean_Expression is

   previewNextToken: Token;
   tok: Token;
   op: Relational_Operator;
   expr1: Expresion_Access;
   expr2: Expression_Access;

begin

   previewNextToken:= get_lookahead_token(p.lex);
      if get_token_type(previewNextToken) = LT_TOK or
        get_token_type(previewNextToken) = LE_TOK or get_token_type(previewNextToken) = GT_TOK
        or get_token_type(previewNextToken) = GE_TOK
        or get_token_type(previewNextToken) = EQ_TOK or get_token_type(previewNextToken) = NE_TOK or
   then

      get_next_token (p.lex, tok);
      op:= get_relational_operator(tok);
      expr1:= get_expression(p);
      expr2:= get_expression(p);
      else
      raise parser_exception with "relational operator token expected at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
      end if;


   return create_boolean_expression(op, expr1, expr2);

end get_boolean_expression;


   function get_relational_operator(tok: in Token) return Relational_Operator is

   op: Relational_Operator;

   begin
      case get_token_type(tok) is
         when LT_TOK =>
         op:= LT_OP;
         when LE_TOK =>
         op:= LE_OP;
         when GT_TOK =>
         op:= GT_OP;
         when GE_TOK =>
         op:= GE_OP;
         when EQ_TOK =>
         op:= EQ_OP;
      when NE_TOK =>
         op:= NE_OP;
      when others =>
         raise parser_exception with "relational operator token expected at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));


   end case;

   return op;
   end get_relational_operator;


function get_expression(p: in out Parser) return Expression_Access is

   expr: Expression_Access;
   previewNextToken: Token;
      tok: Token;
         lexeme: Lexeme;
      op: Arithmetic_Operator;
      literalInteger: Literal_Integer;
   expr1: Expression_Access;
   expr2: Expression_Access;
      var: Id;
      integer: Integer;
      beginning := 1;

begin

   previewNextToken:= get_lookahead_token (p.lex);
   if get_token_type(previewNextToken) = ADD_TOK or get_token_type(previewNextToken) = SUB_TOK or
     get_token_type(previewNextToken) = MUL_TOK or get_token_type(previewNextToken) = DIV_TOK then
      get_next_token (p.lex, tok);
      op:= get_arithmetic_operator(tok);
      expr1:= Expression_Access;
      expr2 := Expression_Access;
      expr:= create_binary_expression(op, expr1, expr2);
   elsif get_token_type (previewNextToken) = ID_TOK then
      get_next_token (p.lex, tok);
      lexeme:= get_lexeme(tok);
         var:= create_id (lexeme(beginning));
         expr:= create_var_expression(var);
      elsif get_token_type(previewNextToken) = LIT_INT then
      get_next_token (p.lex, tok);
            lexeme:= get_lexeme(tok);
            literalInteger := create_literal_integer(integer);
      integer:= Integer'Value(String(lexeme));
            expr:= create_constant_expression(literalInteger);
         end if;

   return expr;
end get_expression;

function get_arithmetic_operator (tok:in Token) return Arithmetic_Operator is

   op: Arithmetic_Operator;

begin
   case get_token_type(tok) is
      when ADD_TOK =>
         op:= ADD_OP;
         when SUB_TOK =>
         op:= SUB_OP;
         when MUL_TOK =>
         op:= MUL_OP;
         when DIV_TOK =>
         op:= DIV_OP;
      when others =>
         raise parser_exception with "Arithmetic operator token expected at row " &
        Positive'Image(get_row_number(tok)) & " and column " &
        Positive'Image(get_column_number(tok));
   end case;

   return op;
   end get_arithmetic_operator;

end Parsers;
