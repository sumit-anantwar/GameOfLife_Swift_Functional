#  Game of Life using Functional Swift
---

There is a two-dimensional grid of cells which can be either alive or dead. From there we calculate each of the following steps with these rules:

### Rules
1. A living cell with 1 or less neighbors dies.
2. A living cell with 4 or more neighbors dies.
3. A living cell with 2 or 3 neighbors continues living.
4. A dead cell with 3 neighbors starts to live
5. A dead cell with 4 or more neighbors remains dead


### Approach
1. Cells are stored in a Simple One-Dimensional MutableArray. Two-Dimensional arrays are usually a pain to manage. 
2. Cell Position is computed by augmenting the Cell Index with the Grid Width

        // Populate the Cells
        for y in 0..<self.gridHeight {
            for x in 0..<self.gridWidth {

                let cell = Cell(x: x, y: y)
                self.cells.append(cell)
            }
        }
        
3. All the neighbours of the cell are pre-coumputed immediatel after populating the Cell Array

        // Pre-Fetch the neighbours so that we can later apply filters directly
        for cell in self.cells {
            cell.neighbours = neighboursForCell(cell: cell)
        }

    **Advantages**
    
    - Once we have the list of neighbours ready at hand, we can easily Count the Alive Neighbours just by filtering the list

            func aliveNeighbourCountForCell(cell: Cell) -> Int {
                return cell.neighbours.filter { $0.state == .Alive }.count
            }
            
    
    - And then applying all the Rules becomes a breeze
    
            // Filter the diying cells
            // Rules ---
            // aliveCell.aliveNeighbours < 2 || > 3
            let dyingCells = aliveCells.filter {
                let aliveNeighbourCount = aliveNeighbourCountForCell(cell: $0)
                return (aliveNeighbourCount < 2) || (aliveNeighbourCount > 3)
            }
    
            // Filter the incarnating cells
            // Rules ---
            // deadCell.aliveNeighbours == 3
            let incarnatingCells = deadCells.filter { aliveNeighbourCountForCell(cell: $0) == 3 }

    
    - After this changing the State of the World becomes as easy as just iterating over all the filtered cells and setting the new state
    
            // Apply the new State
            for cell in incarnatingCells {
                cell.state = .Alive
            }

            for cell in dyingCells {
                cell.state = .Dead
            }
            
    
    ### UI
    1. The Density of the World is controlled by the **worldView.density** property. This property sets the Horizontal Cell Count. Vertical Cell Count is computed automatically
    2. Three buttons have been provided 
    - Play / Pause Button : Starts / Pauses the animation
    - Reset Button : Resets the World to a Random State, and randomly makes 10% of the cells Alive
    - Glider Button : I have also included the famous Glider Gun configuration. This was important for confirming that the Game of Life is really functioning as per the defined Rules.

    3. Legends
    - White Cell  : Unborn, was never Alive or Dead
    - Blue Cell : Alive
    - Light Gray Cell : Dead
    
    
    ### TDD
    1. The App was implemented in a true TDD fasion
    2. All the tests have been implemented in the **WorldTests.swift**
    
