package spacemule.modules.config.objects

import scala.{collection => sc}
import collection.mutable.HashMap
import de.congrace.exp4j.ExpressionBuilder

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 12/20/11
 * Time: 4:19 PM
 * To change this template use File | Settings | File Templates.
 */

object FormulaEval {
  type VarMap = sc.Map[String, Double]
  
  private[this] val formulaCache = HashMap.empty[String, ExpressionBuilder]
  private[this] def resolveExpression(formula: String) = {
    if (formulaCache.contains(formula)) {
      formulaCache(formula)
    }
    else {
      val expression = new ExpressionBuilder(formula.replaceAll("\\*\\*", "^"))
      formulaCache(formula) = expression
      expression
    }
  }

  private[this] def calculateValue(
    expression: ExpressionBuilder, variables: Option[sc.Map[String, Double]]
  ): Double = { 
    (variables match {
      case Some(vars) => vars.foldLeft(expression) { case(exp, (name, value)) =>
        exp.withVariable(name, value)
      }
      case None => expression
    }).build().calculate()
  }

  def eval(formula: String): Double =
    try {
      calculateValue(resolveExpression(formula), None)
    }
    catch {
      case e: Exception =>
        System.err.println(
          "Error while calculating formula '%s'".format(formula)
        )
      throw e
    }
  
  def eval(formula: String, vars: VarMap): Double =
    try {
      calculateValue(resolveExpression(formula), Some(vars))
    }
    catch {
      case e: Exception =>
        throw new IllegalArgumentException(
          "Error while calculating formula '%s' with variables %s".format(
            formula, vars
          ), e
        )
    }
  
  // Just placeholders if formula is not exactly a formula. (When called from
  // jruby side)
  
  def eval(formula: Long) = formula
  def eval(formula: Long, vars: VarMap) = formula
  def eval(formula: Double) = formula
  def eval(formula: Double, vars: VarMap) = formula
}