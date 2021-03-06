/*
 *
 *  Copyright (C) 1994-2016, OFFIS e.V.
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
 *  Module:  dcmdata
 *
 *  Author:  Gerd Ehlers
 *
 *  Purpose: include most dcmdata files that are usually required
 *
 */

#ifndef DCTK_H
#define DCTK_H

#include "osconfig.h"    /* make sure OS specific configuration is included first */

// various headers
#include "dctypes.h"
#include "dcswap.h"
#include "dcistrma.h"
#include "dcostrma.h"
#include "dcvr.h"
#include "dcxfer.h"
#include "dcuid.h"
#include "ofdefine.h"

// tags and dictionary
#include "dctagkey.h"
#include "dctag.h"
#include "dcdicent.h"
#include "dchashdi.h"
#include "dcdict.h"
#include "dcdeftag.h"

// basis classes
#include "dcobject.h"
#include "dcelem.h"

// classes for management of sequences and other lists
#include "dcitem.h"
#include "dcmetinf.h"
#include "dcdatset.h"
#include "dcsequen.h"
#include "dcfilefo.h"
#include "dcdicdir.h"
#include "dcpixseq.h"

// element classes for string management (8-bit)
#include "dcbytstr.h"
#include "dcvrae.h"
#include "dcvras.h"
#include "dcvrcs.h"
#include "dcvrda.h"
#include "dcvrds.h"
#include "dcvrdt.h"
#include "dcvris.h"
#include "dcvrtm.h"
#include "dcvrui.h"
#include "dcvrur.h"

// element classes for string management (8-bit and/or multi-byte)
#include "dcchrstr.h"
#include "dcvrlo.h"
#include "dcvrlt.h"
#include "dcvrpn.h"
#include "dcvrsh.h"
#include "dcvrst.h"
#include "dcvruc.h"
#include "dcvrut.h"

// element class for byte and word value representations
#include "dcvrobow.h"
#include "dcpixel.h"
#include "dcovlay.h"

// element classes for binary value fields
#include "dcvrat.h"
#include "dcvrss.h"
#include "dcvrus.h"
#include "dcvrsl.h"
#include "dcvrul.h"
#include "dcvrulup.h"
#include "dcvrfl.h"
#include "dcvrfd.h"
#include "dcvrof.h"
#include "dcvrod.h"
#include "dcvrol.h"

// misc supporting tools
#include "cmdlnarg.h"

#endif /* DCTK_H */
