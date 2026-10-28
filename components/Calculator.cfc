/**
 * Calculator.cfc
 * Backend logic for the calculator. Uses BigDecimal so results such as
 * 0.1 + 0.2 come out as 0.3 rather than 0.30000000000000004.
 */
component output="false" {

    // Operations the calculator accepts, mapped to the symbol shown to the user.
    variables.operations = {
        add      : "+",
        subtract : "-",
        multiply : "×",
        divide   : "÷"
    };

    public struct function getOperations() {
        return variables.operations;
    }

    /**
     * Validate the inputs and perform the calculation.
     * Always returns a struct: { success, result, expression, message }.
     */
    public struct function calculate(required string a, required string b, required string operation) {
        var response = { success: false, result: "", expression: "", message: "" };

        var x = trim(arguments.a);
        var y = trim(arguments.b);

        if (!isValidNumber(x) || !isValidNumber(y)) {
            response.message = "Please enter a valid number in both fields.";
            return response;
        }

        if (!structKeyExists(variables.operations, arguments.operation)) {
            response.message = "Please choose a valid operation.";
            return response;
        }

        var numA = createObject("java", "java.math.BigDecimal").init(x);
        var numB = createObject("java", "java.math.BigDecimal").init(y);
        var answer = "";

        switch (arguments.operation) {
            case "add":
                answer = numA.add(numB);
                break;
            case "subtract":
                answer = numA.subtract(numB);
                break;
            case "multiply":
                answer = numA.multiply(numB);
                break;
            case "divide":
                if (numB.signum() == 0) {
                    response.message = "Cannot divide by zero.";
                    return response;
                }
                var roundingMode = createObject("java", "java.math.RoundingMode").HALF_UP;
                answer = numA.divide(numB, 10, roundingMode);
                break;
        }

        response.success    = true;
        response.result     = formatResult(answer);
        response.expression = x & " " & variables.operations[arguments.operation] & " " & y;
        return response;
    }

    // Accepts plain decimal numbers only: 12, -3.5, +.5, 7.
    private boolean function isValidNumber(required string value) {
        return reFind("^[+-]?(\d+\.?\d*|\.\d+)$", arguments.value) > 0;
    }

    // Drop trailing zeros and avoid scientific notation.
    private string function formatResult(required any value) {
        if (arguments.value.signum() == 0) {
            return "0";
        }
        return arguments.value.stripTrailingZeros().toPlainString();
    }

}
