# creating_assets

This project is only meant to run on Windows. It will read SVG file and create required BuildingInfoJson File.

### Building Info Class
* Building Number
* List of *coordinates* for each *Side*.
    Each list for every *Side* contains only two elements. Both are starting and ending *coordinates* for that *Side*.

### Coordinate Utility Methods
These methods are intended to use with the Coordinates obtained by the DValue of Building Parameters in the SVG file.

* `getSmallestXCoordinate`
    - Accepts a *List\<Coordinate>* and returns the *coordinate* with the **smallest** X point
* `getLargestXCoordinate`
    - Accepts a *List\<Coordinate>* and returns the *coordinate* with the **largest** X point
* `getSmallestYCoordinate`
    - Accepts a *List\<Coordinate>* and returns the *coordinate* with the **smallest** Y point
* `getLargestYCoordinate`
    - Accepts a *List\<Coordinate>* and returns the *coordinate* with the **largest** Y point
* `getConnectedCoordinates`
    - Accepts a *Coordinate* and a *List\<Coordinate>* with at least 3 elements.
    - Each *coordinate* in the list is assumed to be connected with *coordinates* prior and later *coordinates*. The first and last element of the list are assumened to be connected together. Intended to use with the `dValue` of `Buildings` and `Building Parameter` in the SVG file.
    - Returns a **List\<Coordinate>** with 2 **coordinates**.
* `removeMaxMinCoordinates`
    - Accepts a *List\<Coordinate>*. Removes the *cordinate* with **smallest** and **largest** both X and Y point.
    - It always removes **4 coordinates**. Even if a coordinate has both **largest** X and Y point, it is assumed that this coordinate has the **largest** Y point and **second largest** X point is removed. 
    - Returns a **List\<Coordinate>** with the removed **coordinates**.
* `getTriangleCoordinates`
    - Accepts a *List\<Coordinate>* which contain all the **coordinates of a building**.
    - Each *coordinate* in the list is assumed to be connected with *coordinates* prior and later *coordinates*. The first and last element of the list are assumened to be connected together.
    - Eliminiates the 4 maximum and minimum *coordinates*. Attempts to obtain the `first` *coordinate* which is connected to two of the maximum and minimum *coordinate*. Then, obtains the two *coordinates* connected to the `first` coordinate that complates a **triangle** in the center of the building.
    - Returns a **List\<Coordinate>** with the three coordinates of the **triangle** in the center of the building.
* `getSidesCoordinates`
    - Accepts a *List\<Coordinate>* which contain all the **coordinates of a building** and a *List\<Coordinate>* which contains the three coordinates of the **triangle** in the center of the building.
    - Returns a **Map** with **Side** as *Keys* and **List\<Coordinate>** as *Values*. Each *Value* contains 2 *Coordinates* of the **Side** of the building.

### DValue Parser
This parser is intended to use with the **Buildings Parameter** in the SVG file.
* `normalizeString`
    - Accepts a *String* containing the dValue from the SVG and returns a **String** which is spaced: `M263 68L242.5 55.5 -> M 263 68 L 242.5 55.5`
* `parse`
    - Accepts a *String* and returns a **List\<Coordinate>** in which each *coordinate* is assumed to be connected with *coordinates* prior and later *coordinates*. The first and last element of the list are assumened to be connected together.
* `isCommand`
    - Accepts a *Char* and returns **True** if character is part of SVG dValue.

### SVG Parser
This parser is intended to use with the **Buildings Parameter** in the SVG file. Accepts `XML Element` in constructor which is assumed to be the root element in which all the child elements are path of all the parameters: `<g>...<\g>`
* `parse`
    - Accepts an *XmlElement*
    - *XmlElement* is expected to be a `path` element that is parameter of the building. It should also have an ID attribute with a prefix P followed by the building number: `P24`.
    - Returns **BuildingInfo**
