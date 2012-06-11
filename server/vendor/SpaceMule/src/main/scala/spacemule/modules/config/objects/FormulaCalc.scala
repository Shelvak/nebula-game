package spacemule.modules.config.objects

import scala.{collection => sc}
import collection.mutable.HashMap
import de.congrace.exp4j.ExpressionBuilder
import spacemule.logging.Log

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 12/20/11
 * Time: 4:19 PM
 * To change this template use File | Settings | File Templates.
 */

object FormulaCalc {
  type VarMap = sc.Map[String, Double]
  
  private[this] def resolveExpression(formula: String) =
    new ExpressionBuilder(formula.replaceAll("\\*\\*", "^"))

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

  def calc(formula: String): Double =
    try {
      calculateValue(resolveExpression(formula), None)
    }
    catch {
      case e: Exception => throw core.Exceptions.extend(
        "Error while calculating formula '"+formula+"' without variables", e
      )
    }

  def calc(formula: String, vars: VarMap): Double =
    try {
      calculateValue(resolveExpression(formula), Some(vars))
    }
    catch {
      case e: Exception => throw core.Exceptions.extend(
        "Error while calculating formula '"+formula+"' with variables "+vars, e
      )
    }
  
  // For calling from JRuby.

  def calc(formula: Long) = formula
  def calc(formula: Long, vars: VarMap) = formula
  def calc(formula: Double) = formula
  def calc(formula: Double, vars: VarMap) = formula
}