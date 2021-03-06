/*
 *
 *  Copyright (C) 1994-2005, OFFIS
 *
 *  This software and supporting documentation were developed by
 *
 *    Kuratorium OFFIS e.V.
 *    Healthcare Information and Communication Systems
 *    Escherweg 2
 *    D-26121 Oldenburg, Germany
 *
 *  THIS SOFTWARE IS MADE AVAILABLE,  AS IS,  AND OFFIS MAKES NO  WARRANTY
 *  REGARDING  THE  SOFTWARE,  ITS  PERFORMANCE,  ITS  MERCHANTABILITY  OR
 *  FITNESS FOR ANY PARTICULAR USE, FREEDOM FROM ANY COMPUTER DISEASES  OR
 *  ITS CONFORMITY TO ANY SPECIFICATION. THE ENTIRE RISK AS TO QUALITY AND
 *  PERFORMANCE OF THE SOFTWARE IS WITH THE USER.
 *
 *  Module:  dcmnet
 *
 *  Author:  Marco Eichelberg
 *
 *  Purpose: List class with procedural API compatible to MIR CTN
 */

#ifndef LST_H
#define LST_H

#include "osconfig.h"    /* make sure OS specific configuration is included first */
#include "ofcond.h"
#include "oflist.h"


/** general purpose list class for use with dcmnet module.
 */
class LST_HEAD
{
public:
  /// default constructor
  LST_HEAD();

  /// destructor, deletes list but not elements pointed to by list entries.
  ~LST_HEAD();
  
  /** inserts after the last element of the list.
   *  @param node value inserted into the list
   */
  void push_back(void *node);

  /** removes first element from list and returns it.
   *  Returns NULL if list is empty.
   */
  void *dequeue();

  /** returns number of elements in the list.
   *  @return number of elements
   */
  size_t size() const;

 /** returns the first element in the list.
  *  @return first element in list, NULL if list empty
  */
  void *front();

  /** Make a node current and return the argument.
   *  @param node pointer to element which must be contained in the list
   *  @return pointer to node if successful, NULL otherwise
   */
  void *position(void *node);

  /** Advances the current element to the next element in the list
   *  and returns a pointer to the next element (if any), NULL otherwise.
   *  A valid current element must exist (e.g. position() called with an
   *  existing element), otherwise the behaviour is undefined.
   */
  void *next();

  /** Returns pointer to current element in list.
   *  A valid current element must exist (e.g. position() called with an
   *  existing element), otherwise the behaviour is undefined.
   */
  void *current() const;


private:
  /// the list
  OFList<void *> theList;
  
  /// list iterator, points to current element
  OFListIterator(void *) theIterator;
};


// --------------------------------------------------------------------
// THE FOLLOWING PROCEDURAL API IS COMPATIBLE TO THE MIR CTN LST MODULE
// --------------------------------------------------------------------

/// LST_NODE pseudo-type for MIR List API
typedef void LST_NODE;

/** creates a new list head and returns your handle to it.
 */
LST_HEAD *LST_Create();

/** destroys list. The list must be empty.
 *  The list handle is set to NULL as a side-effect.
 */
OFCondition LST_Destroy(LST_HEAD **lst);

/** Adds a new node to the tail of the list and returns status.
 */
OFCondition LST_Enqueue(LST_HEAD **lst, void *node);

/** Removes a node from the head of the list and returns
 *  a pointer to it.
 */
void *LST_Dequeue(LST_HEAD **lst);

/** alias for LST_Dequeue()
 */
void *LST_Pop(LST_HEAD **lst);

/** Returns the number of nodes in the list.
 */
unsigned int LST_Count(LST_HEAD **lst);

/** Returns a pointer to the node at the head of the list.
 *  It does NOT remove the node from the list.
 */
void *LST_Head(LST_HEAD **lst);

/** Returns a pointer to the current node.
 */
void *LST_Current(LST_HEAD **lst);

/** Returns a pointer to the next node in the list and
 *  makes it current.
 */
void *LST_Next(LST_HEAD **lst);

/** Make a node current and return the argument.
 *  Note:  node = lst_position(list, lst_head(list));
 *         makes the node at the head of the list current
 *         and returns a pointer to it.
 */
void *LST_Position(LST_HEAD **lst, void *node);

#endif

/*
 * CVS Log
 * $Log: lst.h,v $
 * Revision 1.1  2006/03/01 20:15:50  lpysher
 * Added dcmtkt ocvs not in xcode  and fixed bug with multiple monitors
 *
 * Revision 1.5  2005/12/08 16:02:25  meichel
 * Changed include path schema for all DCMTK header files
 *
 * Revision 1.4  2003/06/02 16:44:11  meichel
 * Renamed local variables to avoid name clashes with STL
 *
 * Revision 1.3  2001/10/12 10:17:32  meichel
 * Re-implemented the LST module (double linked list functions)
 *   used in the dcmnet module from scratch based on OFList.
 *
 * Revision 1.2  1999/03/29 11:20:00  meichel
 * Cleaned up dcmnet code for char* to const char* assignments.
 *
 * Revision 1.1.1.1  1996/03/26 18:38:45  hewett
 * Initial Release.
 *
 */
