<cfscript>
    // Default form values so the page renders on first load.
    param name="form.num1"      default="";
    param name="form.num2"      default="";
    param name="form.operation" default="add";

    calculator = new components.Calculator();
    operations = calculator.getOperations();
    outcome    = {};

    // Only calculate when the form was submitted.
    if (cgi.request_method == "POST" && structKeyExists(form, "calculate")) {
        outcome = calculator.calculate(form.num1, form.num2, form.operation);
    }
</cfscript>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CFML Calculator</title>
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <main class="calculator">
        <h1>Calculator</h1>

        <cfoutput>
        <form method="post" action="#encodeForHTMLAttribute(cgi.script_name)#" novalidate>
            <div class="field">
                <label for="num1">First number</label>
                <input type="text" id="num1" name="num1" inputmode="decimal" autocomplete="off"
                       value="#encodeForHTMLAttribute(form.num1)#" autofocus>
            </div>

            <div class="field">
                <label for="operation">Operation</label>
                <select id="operation" name="operation">
                    <cfloop collection="#operations#" item="key">
                        <option value="#key#" <cfif form.operation EQ key>selected</cfif>>
                            #operations[key]# #key#
                        </option>
                    </cfloop>
                </select>
            </div>

            <div class="field">
                <label for="num2">Second number</label>
                <input type="text" id="num2" name="num2" inputmode="decimal" autocomplete="off"
                       value="#encodeForHTMLAttribute(form.num2)#">
            </div>

            <button type="submit" name="calculate" value="1">Calculate</button>
        </form>

        <cfif NOT structIsEmpty(outcome)>
            <cfif outcome.success>
                <div class="result success" role="status">
                    <span class="expression">#encodeForHTML(outcome.expression)# =</span>
                    <strong>#encodeForHTML(outcome.result)#</strong>
                </div>
            <cfelse>
                <div class="result error" role="alert">#encodeForHTML(outcome.message)#</div>
            </cfif>
        </cfif>
        </cfoutput>
    </main>
</body>
</html>
