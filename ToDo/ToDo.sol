// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

/*
 * @title: ToDo contract.
 * @author: Anthony (fps) https://github.com/fps8k .
 * @dev: 
*/

contract ToDo
{
    enum State
    {
        notStarted,
        started,
        finished
    }




    struct Activity
    {
        string name;
        State state;
    }




    mapping(uint256 => Activity) public todos;
    uint256 private count = 1;




    function add(string memory _name) public
    {
        Activity memory activity;

        activity.name = _name;
        activity.state = State.notStarted;

        todos[count] = activity;
        count ++;
    }




    function start(uint _index) public
    {
        Activity storage activity = todos[_index];
        activity.state = State.started;
    }




    function finish(uint _index) public
    {
        Activity storage activity = todos[_index];
        activity.state = State.finished;
    }




    function remove(uint _index) public
    {
        delete todos[_index];
    }




    function reset(uint _index) public
    {
        Activity storage activity = todos[_index];
        activity.state = State.notStarted;
    }
}