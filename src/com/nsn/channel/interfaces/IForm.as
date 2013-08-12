package com.nsn.channel.interfaces 
{
	/*
	 * The interface for all Form classes
	 */
	
	public interface IForm 
	{
		
		function getLabelHeight( ):Number ;
		function getLabel( ):String ;
		function getWidth( ):Number ;
		function getHeight( ):Number ;
		function getData( ):XML ;
		function getValue( ):* ;
		function setValue( val:* ):void ;
		
		function validate( ):void ;
		function reset( ):void ;
		function clear( ):void ;
		
	}
	
}