

\begin{code}

module Amb (AmbT, Amb, amb, cut, runAmbT, runAmb) where
 
import Control.Monad.Cont
import Control.Monad.State
import Control.Monad.Identity
 
newtype AmbT r m a = AmbT { unAmbT :: StateT [AmbT r m r] (ContT r m) a }  -- deriving Show
type Amb r = AmbT r Identity
 
instance MonadTrans (AmbT r) where
    lift = AmbT . lift . lift
 
instance (Monad m) => Monad (AmbT r m) where
    AmbT a >>= b = AmbT $ a >>= unAmbT . b
    return = AmbT . return
 
backtrack :: (Monad m) => AmbT r m a
backtrack = do xss <- AmbT get
               case xss of
                 [] -> fail "amb tree exhausted"
                 (f:xs) -> do AmbT $ put xs; f; return undefined
 
addPoint :: (Monad m) => (() -> AmbT r m r) -> AmbT r m ()
addPoint x = AmbT $ modify (x () :)
 
amb :: (Monad m) => [a] -> AmbT r m a
amb []     = backtrack
amb (x:xs) = ambCC $ \exit -> do
               ambCC $ \k -> addPoint k >> exit x
               amb xs
    where ambCC f = AmbT $ callCC $ \k -> unAmbT $ f $ AmbT . k
 
cut :: (Monad m) => AmbT r m ()
cut = AmbT $ put []
 
runAmbT :: (Monad m) => AmbT r m r -> m r
runAmbT (AmbT a) = runContT (evalStateT a []) return
 
runAmb :: Amb r r -> r
runAmb = runIdentity . runAmbT

\end{code}

