# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

# BONUS QUESTIONS: These problems require knowledge of aggregate
# functions. Attempt them after completing section 05.

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
    SELECT name
    FROM countries
    WHERE gdp > (
      SELECT MAX(COALESCE(gdp, 0))
      FROM countries
      WHERE continent = 'Europe'
    )
  SQL
end

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
    SELECT a.continent, a.name, a.area
    FROM countries a
    JOIN (
      SELECT MAX(area) as max_area, continent
      FROM countries
      GROUP BY continent
    ) AS b ON a.continent = b.continent
    WHERE a.area = b.max_area;
  SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
    SELECT DISTINCT a.name, a.continent, a.name, b.continent
    FROM countries a
    JOIN countries b ON a.continent = b.continent AND a.name != b.name
    JOIN (
      SELECT MAX(population) as max_pop, continent
      FROM countries
      GROUP BY continent
    ) AS c ON a.continent = c.continent
    WHERE a.population > 3 * b.population AND a.population = c.max_pop
  SQL
end

#  WHERE a.population > 3 * b.population AND a.population
