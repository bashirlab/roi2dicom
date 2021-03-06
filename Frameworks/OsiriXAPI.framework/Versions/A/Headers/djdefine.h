/*
 *
 *  Copyright (C) 2011, OFFIS e.V.
 *  All rights reserved.  See COPYRIGHT file for details.
 *
 *  This software and supporting documentation were developed by
 *
 *    OFFIS e.V.
 *    R&D Division Health
 *    Escherweg 2
 *    D-26121 Oldenburg, Germany
 *
 *
 *  Module:  dcmjpeg
 *
 *  Author:  Uli Schlachter
 *
 *  Purpose: Contains preprocessor definitions
 *
 */


#ifndef DJDEFINE_H
#define DJDEFINE_H

#include "osconfig.h"

#include "ofdefine.h"


#ifdef dcmjpeg_EXPORTS
#define DCMTK_DCMJPEG_EXPORT DCMTK_DECL_EXPORT
#else
#define DCMTK_DCMJPEG_EXPORT DCMTK_DECL_IMPORT
#endif


#endif
