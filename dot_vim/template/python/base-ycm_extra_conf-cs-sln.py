import os.path
import logging


def CSharpSolutionFile(filepath):
    sln = {{_cursor_}}
    handler = logging.FileHandler(os.path.expanduser('~/.ycm_extra_conf.log'))
    handler.setLevel(logging.INFO)
    logger = logging.getLogger(__name__)
    logger.addHandler(handler)
    logger.info('Got filepath value "%s" in CSharpSolutionFile function', filepath)
    logger.info('<- %s', os.path.join(os.path.dirname(__file__), sln))
    return os.path.join(os.path.dirname(__file__), sln)
