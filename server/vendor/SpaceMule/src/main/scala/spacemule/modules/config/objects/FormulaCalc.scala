package spacemule.modules.config.objects

import scala.{collection => sc}
import collection.mutable.HashMap
import de.congrace.exp4j.ExpressionBuilder
import spacemule.helpers.Exceptions.wrappingException
import spacemule.helpers.JRuby._
import org.jruby.RubyHash

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 12/20/11
 * Time: 4:19 PM
 * To change this template use File | Settings | File Templates.
 */

object FormulaCalc {
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

  implicit private[this] def exceptionWrapper =
    (message: String, cause: Exception) => {
      new IllegalArgumentException(message, cause)
    }

  def calc(formula: String): Double =
    wrappingException(
      "Error while calculating formula '%s' without variables.".format(
        formula
      )
    ) { () => calculateValue(resolveExpression(formula), None) }
  
  def calc(formula: String, vars: VarMap): Double =
    wrappingException(
      "Error while calculating formula '%s' with variables %s".format(
        formula, vars
      )
    ) { () =>
      calculateValue(resolveExpression(formula), Some(vars))
    }

  def calc(formula: String, vars: RubyHash): Double =
    wrappingException(
      "Error while calculating formula '%s' with variables %s".format(
        formula, vars
      )
    ) { () =>
      calculateValue(resolveExpression(formula), Some(
        vars.asScalaMap(_.toString, _.asDouble)
      ))
    }
  
  // Just placeholders if formula is not exactly a formula. (When called from
  // JRuby side)
  
  def calc(formula: Long) = formula
  def calc(formula: Long, vars: VarMap) = formula
  def calc(formula: Long, vars: RubyHash) = formula
  def calc(formula: Double) = formula
  def calc(formula: Double, vars: VarMap) = formula
  def calc(formula: Double, vars: RubyHash) = formula
}