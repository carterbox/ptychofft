# This file was automatically generated by SWIG (http://www.swig.org).
# Version 2.0.10
#
# Do not make changes to this file unless you know what you are doing--modify
# the SWIG interface file instead.



from sys import version_info
if version_info >= (2,6,0):
    def swig_import_helper():
        from os.path import dirname
        import imp
        fp = None
        try:
            fp, pathname, description = imp.find_module('_ptychofft', [dirname(__file__)])
        except ImportError:
            import _ptychofft
            return _ptychofft
        if fp is not None:
            try:
                _mod = imp.load_module('_ptychofft', fp, pathname, description)
            finally:
                fp.close()
            return _mod
    _ptychofft = swig_import_helper()
    del swig_import_helper
else:
    import _ptychofft
del version_info
try:
    _swig_property = property
except NameError:
    pass # Python < 2.2 doesn't have 'property'.
def _swig_setattr_nondynamic(self,class_type,name,value,static=1):
    if (name == "thisown"): return self.this.own(value)
    if (name == "this"):
        if type(value).__name__ == 'SwigPyObject':
            self.__dict__[name] = value
            return
    method = class_type.__swig_setmethods__.get(name,None)
    if method: return method(self,value)
    if (not static):
        self.__dict__[name] = value
    else:
        raise AttributeError("You cannot add attributes to %s" % self)

def _swig_setattr(self,class_type,name,value):
    return _swig_setattr_nondynamic(self,class_type,name,value,0)

def _swig_getattr(self,class_type,name):
    if (name == "thisown"): return self.this.own()
    method = class_type.__swig_getmethods__.get(name,None)
    if method: return method(self)
    raise AttributeError(name)

def _swig_repr(self):
    try: strthis = "proxy of " + self.this.__repr__()
    except: strthis = ""
    return "<%s.%s; %s >" % (self.__class__.__module__, self.__class__.__name__, strthis,)

try:
    _object = object
    _newclass = 1
except AttributeError:
    class _object : pass
    _newclass = 0


class ptychofft(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, ptychofft, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, ptychofft, name)
    __repr__ = _swig_repr
    def __init__(self, *args): 
        this = _ptychofft.new_ptychofft(*args)
        try: self.this.append(this)
        except: self.this = this
    __swig_destroy__ = _ptychofft.delete_ptychofft
    __del__ = lambda self : None;
    def setobjc(self, *args): return _ptychofft.ptychofft_setobjc(self, *args)
    def fwdc(self, *args): return _ptychofft.ptychofft_fwdc(self, *args)
    def adjc(self, *args): return _ptychofft.ptychofft_adjc(self, *args)
    def setobj(self, *args): return _ptychofft.ptychofft_setobj(self, *args)
    def fwd(self, *args): return _ptychofft.ptychofft_fwd(self, *args)
    def adj(self, *args): return _ptychofft.ptychofft_adj(self, *args)
ptychofft_swigregister = _ptychofft.ptychofft_swigregister
ptychofft_swigregister(ptychofft)

# This file is compatible with both classic and new-style classes.


